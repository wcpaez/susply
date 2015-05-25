Susply::Engine.routes.draw do
  resource :change_plan, only: [:create]
  resources Susply.owner_resource, as: :owner, only: [:show] do
    resources :renovations, only: [:create]
  end
end
