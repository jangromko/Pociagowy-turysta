load 'graf.rb'
load 'mrowka.rb'
require 'json'
load 'funkcje.rb'

class AlgorytmController < ApplicationController

  def pobierz_wynik
    plik = IO.read('/home/jg/Pulpit/wynik.json')
    json = JSON.parse(plik)
    render json: json
  end

  def pokaz_wynik

    czas_zwiedzania = request.query_parameters['czas_zwiedzania'].to_i
    miasto_startowe = request.query_parameters['miasto_startowe']
    wybor_czasu = request.query_parameters['wybierz_czas']

    sztywne_ustawienia = false

    if wybor_czasu == 'tak'
      godzina = request.query_parameters['godzina'].to_i
      minuta = request.query_parameters['minuta'].to_i
      czas_start = godzina*60+minuta
      sztywne_ustawienia = true
    end

    plik = IO.read('/home/jg/Pulpit/rozklad.json')
    rozklad = JSON.parse(plik)
    graf = Graf.new
    graf.utworz_z_jsona(rozklad)


    najlepszy_koszt = 1.0/0
    najlepsza_trasa = nil
    kiedy_znaleziona = 0


    mrowy = []


    for j in 0..0

      if sztywne_ustawienia
        for i in 0..0
          mrowy[i] = Mrowka.new(graf.wierzcholki[miasto_startowe], 99, graf, czas_zwiedzania, czas_start)
        end
      else
        for i in 0..0
          mrowy[i] = Mrowka.new(graf.wierzcholki['Warszawa'], 99, graf, czas_zwiedzania)
        end
      end



      mrowy.each do |mrowa|
        mrowa.wykonaj_pelna_trase
      end


      suma = 0
      sukcesy = 0
      mrowy.each do |mrowa|
        if mrowa.status == 1
          sukcesy += 1
          if mrowa.koszt < najlepszy_koszt
            najlepszy_koszt = mrowa.koszt
            najlepsza_trasa = mrowa.trasa
            kiedy_znaleziona = j

          end
          print mrowa.koszt
          print ':'
          print mrowa.trasa.trasa_szczegoly.size
          print '+'
          print mrowa.trasa.powrotna_trasa_szczegoly.size
          print ' '
          suma += mrowa.koszt
        end
      end

      if sukcesy > 0
        puts ''

        puts '–––––––––––––––––––'
        puts j
        print 'ŚREDNIA: '
        puts suma/sukcesy
        print 'NAJLEPSZY: '
        puts najlepszy_koszt
        puts '–––––––––––––––––––'
      end

      if najlepszy_koszt < czas_zwiedzania*99+27000
        break
      end

#=begin
      graf.odparuj(0.05)

      mrowy.each do |mrowa|
        if mrowa.status == 1
          mrowa.trasa.trasa_ogolna do |krawedz|
            krawedz.dodaj_feromon(sigmoidalna_rozmiar(mrowa.trasa.trasa_szczegoly.size), 0.01)
            krawedz.dodaj_feromon(sigmoidalna_koszt(mrowa.koszt), 2)
          end
        end
      end

      najlepsza_trasa.trasa_ogolna.each do |krawedz|
        krawedz.dodaj_feromon(sigmoidalna_rozmiar(najlepsza_trasa.trasa_szczegoly.size), 0.01)
        krawedz.dodaj_feromon(sigmoidalna_koszt(najlepszy_koszt), 2)
      end
#=end
    end



    puts najlepsza_trasa.trasa_szczegoly
    puts 'POWRÓT:'
    puts najlepsza_trasa.powrotna_trasa_szczegoly
    puts najlepszy_koszt
    puts najlepsza_trasa.trasa_szczegoly.size.to_s + ' + ' + najlepsza_trasa.powrotna_trasa_szczegoly.size.to_s
    puts kiedy_znaleziona

    wynik_json = []

    najlepsza_trasa.trasa_szczegoly.each do |t|
      wynik_json.push t.to_map
    end

    najlepsza_trasa.powrotna_trasa_szczegoly.each do |t|
      wynik_json.push t.to_map
    end

    File.open('/home/jg/Pulpit/wynik.json', "w") do |plik_wyj|
      plik_wyj.puts wynik_json.to_json
    end

    File.open('/home/jg/Pulpit/wynik_koszt', "w") do |plik_wyj|
      plik_wyj.puts (najlepszy_koszt/1440).to_s + ' dni ' + ((najlepszy_koszt-(najlepszy_koszt/1440)*1440)/60).to_s + ' godzin(y) ' + ((najlepszy_koszt-(najlepszy_koszt/1440)*1440)%60).to_s + ' minut(y)'
    end

    render 'pokaz_wynik'
  end

  def index

  end

end
