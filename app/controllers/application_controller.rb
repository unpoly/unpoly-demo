class ApplicationController < ActionController::Base
  include Memoized

  before_action :create_missing_tenant

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

  memoize def current_tenant
    if (tenant_id = session[:tenant_id].presence)
      Tenant.for_current_schema.where(id: tenant_id).first
    end
  end

end
