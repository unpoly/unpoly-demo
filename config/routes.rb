Rails.application.routes.draw do
  root to: 'companies#index'

  resources :projects do
    collection do
      get :suggest_name
    end
  end

  resources :budgets
  resources :companies

  get 'verify_tenant', to: 'tenants#verify', as: :verify_tenant
end
