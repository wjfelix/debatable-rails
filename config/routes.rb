Rails.application.routes.draw do

  post 'firetalk_debaters/destroy', to: 'firetalk_debaters#destroy'

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller

  root 'home#index'

  get '/feedbacks/new', to: 'feedbacks#new'
  post '/feedbacks/new', to: 'feedbacks#create'

  get 'home/news'
  get '/login', to: 'sessions#new'
  get '/logout', to: 'sessions#destroy'
  get '/join', to: 'debates#join'

  post '/login', to: 'sessions#create'
  post '/subscribe', to: 'home#save_subscription'

  get '/change_password', to: 'users#change_password'
  post '/update_password', to: 'users#update_password'

  get '/forgot_password', to: 'users#forgot_password'
  post '/forgot_password', to: 'users#reset_password'

  get '/users', to: 'users#index'

  get '/invites', to: 'application#grab_invites'
  put '/invites', to: 'invites#update'

  get '/join_random_firetalk', to: 'random_firetalks#join'
  get '/watch_random_firetalk', to: 'random_firetalks#watch'

  get '/join_firetalk', to: 'firetalks#join'

  get '/firetalk_message', to: 'firetalk_messages#new'
  post '/firetalk_message', to: 'firetalk_messages#create'

  resources :users do
    get :validate_email
    resources :debates
    resources :firetalks
  end

end
