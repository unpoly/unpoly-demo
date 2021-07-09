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

  get 'verify_tenant', to: 'tenants#verify', as: :verify_tenant

  match '/slow_image.png', via: :get, to: 'pages#slow_image'
  match '/slow_font.ttf', via: :get, to: 'pages#slow_font'
  match '/slow_style.css', via: :get, to: 'pages#slow_style'
  match '/slow_script.js', via: :get, to: 'pages#slow_script'
  match '/slow_script2.js', via: :get, to: 'pages#slow_script2'
  match '/slow_script3.js', via: :get, to: 'pages#slow_script3'

end
