Footmanager::Application.routes.draw do

  devise_for :users
  root :to => redirect('week_calendar')
  get 'documents', to: 'static_pages#documents'
  get 'news', to: 'static_pages#news'
  get 'week_calendar', to: 'static_pages#week_calendar'

  resource :api, controller: :api do
    get :find_player
  end

  get 'contracts/destroy/:id', to: 'contracts#destroy'
  get 'contracts/destroy/:team_id/:player_id', to: 'contracts#destroy'
  get 'contracts/close/:id', to: 'contracts#close'
  get 'contracts/close/:team_id/:player_id', to: 'contracts#destroy'
  resources :contracts


  resources :team_logos
  resources :posts

  resources :players
  resources :champs do
    collection do
      get :archive
    end
    member do
      get :teams
      get :schedule
      get :stats
      get :disq
    end
    resources :stages do
      member do
        get :ring_games_generate
        get :ring_games_swap_from_stage
      end
      resources :games
    end
    resources :teams do
      member do
        resources :contracts
        get :players
        get :games
      end
    end
  end


end
