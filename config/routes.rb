Rails.application.routes.draw do
  root to: 'pages#home'

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
      patch :finish
      patch :unfinish
      patch :move
    end
  end

  get 'placeholders/index', to: 'placeholders#index'
  get 'placeholders/table', to: 'placeholders#table'
  get 'placeholders/show', to: 'placeholders#show'
  get 'placeholders/form', to: 'placeholders#form'

  get 'verify_tenant', to: 'tenants#verify', as: :verify_tenant
end
