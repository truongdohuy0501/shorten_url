Rails.application.routes.draw do
  root to: "short_urls#encode"
  get "/encode", to: "short_urls#encode"
  get "/decode", to: "short_urls#decode"
  get "shorted/:shorted_url", to: "short_urls#shorted", as: :shorted
  post 'decode_url', to: 'short_urls#decode_shorted_url'
  post 'encode_url', to: 'short_urls#create'
end
