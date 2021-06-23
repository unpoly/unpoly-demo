Rails.application.routes.draw do
  root to: 'companies#index'

  resources :projects do
    collection do
      get :suggest_name
    end
  end

  resources :companies

  resources :tasks do
    collection do
      delete :clear_done
    end
    member do
      patch :toggle_done
    end
  end

  get 'verify_tenant', to: 'tenants#verify', as: :verify_tenant
end
