Susply::Engine.routes.draw do
  resources Susply.owner_resource, as: :owner, only: [] do
    resources :renovations, only: [:create]
  end
end
