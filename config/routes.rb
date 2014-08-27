Rails.application.routes.draw do
  match "*any", to: "api/v1/base#options", via: :all, constraints: { method: "OPTIONS" }

  use_doorkeeper

  if Rails.env.production? and not ENV["STORAGE_SUBDOMAIN_DISABLED"]
    get "*id", to: "files#serve", format: false, constraints: { subdomain: "storage" }
  else
    get "storage/*id", to: "files#serve", format: false
  end

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      get "users/current", to: "users#current"

      resources :planets, only: [:index                ]
      resources :objects, only: [:index                ]
      resources :games,   only: [        :show, :create] { member { put :invite; put :turn; } }
    end
  end

  post "canvas", to: "pages#canvas"

  get "auth/:provider/callback", to: "sessions#create"
  get "logout",                  to: "sessions#destroy", as: :logout

  root to: "pages#home"
end
