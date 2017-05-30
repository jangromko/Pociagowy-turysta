Rails.application.routes.draw do
  get 'mapa/index'
  get 'mapa/json'
  get 'mapa/czasy'
  get 'mapa/json2'

  get 'algorytm/pobierz_wynik'
  get 'algorytm/pokaz_wynik'
  get 'algorytm/index'

  root 'algorytm#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
