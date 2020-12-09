class TenantsController < ApplicationController
  skip_before_action :create_missing_tenant

  def verify
    if current_tenant
      return_to = session[:return_to].presence || root_url
      redirect_to return_to
    else
      render text: 'This demo requires cookies'
    end

  end

end
