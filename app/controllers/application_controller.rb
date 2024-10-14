class ApplicationController < ActionController::Base
  include Memoized

  before_action :reset_faker
  before_action :create_missing_tenant
  after_action :emulate_latency

  private

  def create_missing_tenant
    unless current_tenant
      tenant = Tenant.create!
      session[:tenant_id] = tenant.id
      session[:return_to] = request.original_url

      # This action checks if the user has cookies enables,
      # then redirects back to the current poath.
      redirect_to verify_tenant_path
    end
  end

  helper_method memoize def current_tenant
    if (tenant_id = session[:tenant_id].presence)
      Tenant.for_current_schema.where(id: tenant_id).first
    end
  end

  helper_method memoize def fragment_explainer
    FragmentExplainer.new(self)
  end

  def reset_faker
    # The model is asking Faker to produce unique names in Tenent.create, Project.suggest_name, etc.
    # We must periodically release the list of used names or Faker will eventually throw errors.
    # See https://github.com/faker-ruby/faker#ensuring-unique-values
    Faker::UniqueGenerator.clear
  end

  def emulate_latency
    if up? && request.headers['X-Extra-Latency'].present? && !response.redirect?
      sleep 1.0
    end
  end

end
