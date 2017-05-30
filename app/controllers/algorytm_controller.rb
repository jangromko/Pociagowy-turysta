class AlgorytmController < ApplicationController

  def pobierz_wynik
    plik = IO.read('/home/jg/Pulpit/wynik.json')
    json = JSON.parse(plik)
    render json: json
  end

  def pokaz_wynik

  end

  def index

  end

end
