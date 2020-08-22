Rails.application.routes.draw do
  root to: 'projects#index'

  resources :projects do
    collection do
      get :suggest_name
    end

    resource :deadline, only: [:edit, :update], controller: 'projects/deadlines'
  end

  resources :budgets
  resources :companies
end
