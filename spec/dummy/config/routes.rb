Rails.application.routes.draw do
  mount Susply::Engine => "/susply", as: 'susply'
end
