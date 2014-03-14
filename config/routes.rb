Footmanager::Application.routes.draw do

  devise_for :users
  root 'champs#index'
  resource :api, controller: :api do
    get :find_player
  end

  resources :players
  resources :champs do
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
      end
    end
  end


end
