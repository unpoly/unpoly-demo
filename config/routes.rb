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
      patch :toggle_done
    end
  end

  get 'skeletons/index', to: 'skeletons#index'
  get 'skeletons/table', to: 'skeletons#table'
  get 'skeletons/show', to: 'skeletons#show'
  get 'skeletons/form', to: 'skeletons#form'

  get 'verify_tenant', to: 'tenants#verify', as: :verify_tenant
end
