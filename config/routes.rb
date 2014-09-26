BoshArtifacts::Application.routes.draw do
  root "root#show"
  resources :file_collections, only: [:index]
  get '/api/latest_stemcell', to: 'api#latest_stemcell'
  get '/api/latest_release', to: 'api#latest_release'
end
