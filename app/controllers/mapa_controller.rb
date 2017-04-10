class MapaController < ApplicationController

  def index
  end

  def json
    plik = IO.read('/home/jg/Dokumenty/VI semestr/GiS/Projekt/rozklad_dla_calej_polski.json')
    json = JSON.parse(plik)
    render json: json
  end
end
