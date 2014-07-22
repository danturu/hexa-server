Rails.application.routes.draw do
  match "*options" => "api/v1/base#options", via: :all, constraints: { method: "OPTIONS" }

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
    end
  end
end
