Rails.application.routes.draw do
  match "*options", to: "api/v1/base#options", via: :all, constraints: { method: "OPTIONS" }

  use_doorkeeper

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :planets, only: [:index                ]
      resources :games,   only: [:index, :show, :create]
      resources :moves,   only: [               :create]
    end
  end

  get "auth/:provider/callback", to: "sessions#create"
  get "logout",                  to: "sessions#destroy",   as: :logout
  get "launch",                  to: "application#launch", as: :launch

  root to: "pages#home"
end