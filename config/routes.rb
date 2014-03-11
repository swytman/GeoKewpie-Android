Footmanager::Application.routes.draw do

  devise_for :users
  root 'champs#index'
  resources :champs do
    resources :stages do
      member do
        get :ring_games_generate
        get :ring_games_swap_from_stage
      end
      resources :games
    end
    resources :teams
  end


end
