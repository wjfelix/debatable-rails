Rails.application.routes.draw do

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller

  root 'home#index'

  get 'home/news'
  get '/login', to: 'sessions#new'
  get '/logout', to: 'sessions#destroy'
  get '/join', to: 'debates#join'

  post '/login', to: 'sessions#create'
  post '/subscribe', to: 'home#save_subscription'

  get 'change_password', to: 'users#change_password'
  post 'update_password', to: 'users#update_password'

  get '/forgot_password', to: 'users#forgot_password'
  post '/reset_password', to: 'users#reset_password'

  resources :users do
    get :validate_email
    resources :debates
    resources :firetalks
  end
end
