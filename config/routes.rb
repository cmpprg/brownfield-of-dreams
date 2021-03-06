Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      resources :tutorials, only:[:show, :index]
      resources :videos, only:[:show]
    end
  end

  root 'welcome#index'
  get 'tags/:tag', to: 'welcome#index', as: :tag
  get '/register', to: 'users#new'
  get '/signup', to: 'users#new'

  namespace :admin do
    get "/dashboard", to: "dashboard#show"
    resources :tutorials, only: [:create, :edit, :update, :destroy, :new] do
      resources :videos, only: [:create]
    end

    resources :videos, only: [:edit, :update, :destroy]

    namespace :api do
      namespace :v1 do
        put "tutorial_sequencer/:tutorial_id", to: "tutorial_sequencer#update"
      end
    end
    resources :import_playlist, only:[:new, :create]
  end

  get '/login', to: "sessions#new"
  post '/login', to: "sessions#create"
  delete '/logout', to: "sessions#destroy"

  get '/dashboard', to: 'users#show'
  get '/about', to: 'about#show'
  get '/get_started', to: 'get_started#show'

  resources :users, only: [:new, :create, :update, :edit]

  get '/invite', to: 'invites#new', as: 'invite'
  post '/invite', to: 'invites#create'

  resources :tutorials, only: [:show, :index] do
    resources :videos, only: [:show, :index]
  end

  resources :user_videos, only:[:create, :destroy]
  get '/auth/github/callback', to: 'sessions#update'

  get '/account_activation/:id', to: 'account_activation#show', as: 'account_activation'
  post '/friendships', to: 'friendships#create'
end
