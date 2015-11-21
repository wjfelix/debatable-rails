Rails.application.routes.draw do

  get 'debates/create'

  get 'debates/index'

  get 'debates/new'

  get 'debates/show'

  get 'debates/destroy'

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller

  root 'home#index'

  resources :users do
    get :validate_email
    resources :debates
  end

  get 'home/news'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
end
