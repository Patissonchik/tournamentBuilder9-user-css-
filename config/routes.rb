Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }
  root to:"tournaments#index"
  resources :tournaments do
    resources :matches do
      resources :match_stats
    end
  end
  put '/tournaments/:tournament_id/matches/:match_id/match_stats', to: 'match_stats#update', as: 'update_match_stats'

end
