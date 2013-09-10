BoshArtifacts::Application.routes.draw do
  root "root#show"
  resources :file_collections, only: [:index]
end
