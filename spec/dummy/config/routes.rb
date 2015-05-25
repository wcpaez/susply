Rails.application.routes.draw do
  resources :companies
  mount Susply::Engine => "/susply", as: 'susply'
end
