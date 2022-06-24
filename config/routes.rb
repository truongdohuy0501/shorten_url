Rails.application.routes.draw do
  root to: "short_urls#encode"
  get "/index", to: "short_urls#index"
  get "/show/:short_url", to: "short_urls#show"
  get "/encode", to: "short_urls#encode"
  get "/decode", to: "short_urls#decode"
  get "shorted/:short_url", to: "short_urls#shorted", as: :shorted
  resource :short_urls, only: :create

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :short_urls, only: %w[decode_shorted_url encode_shorted_url] do
        post "decode_shorted_url", on: :collection
        post "encode_shorted_url", on: :collection
      end
    end
  end
end
