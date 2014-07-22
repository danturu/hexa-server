Rails.application.routes.draw do
  match "*any", to: "api/v1/base#options", via: :all, constraints: { method: "OPTIONS" }

  use_doorkeeper

  if Rails.env.production?
    get "*id", to: "files#serve", format: false, constraints: { subdomain: "storage" }
  else
    get "storage/*id", to: "files#serve", format: false
  end

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