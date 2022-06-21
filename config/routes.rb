Rails.application.routes.draw do
  root to: "short_urls#index"
  get "/:shorted_url", to: "short_urls#show"
  get "shorted/:shorted_url", to: "short_urls#shorted", as: :shorted
  resources :short_urls , only: :create
end
