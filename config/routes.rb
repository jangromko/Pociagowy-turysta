Rails.application.routes.draw do
  get 'mapa/index'
  get 'mapa/json'

  root 'mapa#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
