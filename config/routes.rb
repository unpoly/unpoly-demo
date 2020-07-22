Rails.application.routes.draw do
  root to: 'projects#index'

  resources :projects do
    collection do
      get :suggest_name
    end
  end

  resources :budgets
  resources :companies
end
