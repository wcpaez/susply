Susply::Engine.routes.draw do
  resources Susply.owner_resource, as: :owner, only: [:show] do
    resources :renovations, only: [:create]
  end
end
