Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "movies#index"
  get '/movies/filter', to: 'movies#index', as: :filtered_movies
  # resources :reviews, only: [:destroy]
  resources :movies do
    resources :reviews
    resources :likes
  end
  resources :users
  get '/signup', to: "users#new"
  resource :session, only: [:create]
  get '/signin', to: "sessions#new"
  get '/signout', to: 'sessions#destroy'

  # root 'movies#index'
  # get '/movies', to: 'movies#index'
  # get '/movies/new', to: 'movies#new'
  # get '/movies/:id', to: 'movies#show', as: :movie
  # post '/movies', to: 'movies#create'
  # get '/movies/:id/edit', to: 'movies#edit', as: :edit_movie
  # patch '/movies/:id', to: 'movies#update'
  # delete '/movies/:id', to: 'movies#destroy'
end
