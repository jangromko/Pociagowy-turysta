load 'polaczenie.rb'
load 'krawedz.rb'
load 'funkcje.rb'
require 'set'

class Trasa

  def initialize
    @trasa_ogolna = Set.new
    @trasa_szczegoly = []
    @powrotna_trasa_ogolna = Set.new
    @powrotna_trasa_szczegoly = []
  end

  def dolacz_krawedz(krawedz, polaczenie)
    @trasa_ogolna.add(krawedz)
    @trasa_szczegoly.push(polaczenie)
  end

  def dolacz_polaczenie(polaczenie)
    @trasa_szczegoly.push(polaczenie)
  end

  def dolacz_krawedz_powrotna(krawedz, polaczenie)
    @powrotna_trasa_ogolna.add(krawedz)
    @powrotna_trasa_szczegoly.push(polaczenie)
  end

  def dolacz_trase(trasa)
    @trasa_ogolna += trasa.trasa_ogolna
    @trasa_szczegoly += trasa.trasa_szczegoly
    @powrotna_trasa_ogolna += trasa.powrotna_trasa_ogolna
    @powrotna_trasa_szczegoly += trasa.powrotna_trasa_szczegoly
  end

  def lista_miast
    miasta = []

    @trasa_szczegoly.each do |p|
      miasta.push(p.miasto_docelowe)
    end

    miasta
  end

  def czesc_trasy(poczatek, koniec)
    wynik = Trasa.new
    wynik.trasa_ogolna = @trasa_ogolna
    wynik.trasa_szczegoly = @trasa_szczegoly[poczatek..koniec]

    wynik
  end

  def wylicz_czas(czas_startowy, start, koniec)
    wynik = 0
    czas = czas_startowy

    for i in start..koniec
      wynik += roznica_czasu(czas, @trasa_szczegoly[i].odjazd)
      wynik += @trasa_szczegoly[i].czas

      czas = dodaj_do_czasu(czas, roznica_czasu(czas, @trasa_szczegoly[i].przyjazd))
    end

    wynik
  end

  def wyczysc
    @trasa_ogolna = Set.new
    @trasa_szczegoly = []
  end

  attr_accessor :trasa_ogolna, :trasa_szczegoly, :powrotna_trasa_ogolna, :powrotna_trasa_szczegoly
end