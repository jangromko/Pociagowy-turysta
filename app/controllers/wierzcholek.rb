load 'krawedz.rb'
require 'set'

class Wierzcholek
  def initialize(nazwa)
    @nazwa = nazwa
    @krawedzie = {}
    @sasiedzi = Set.new
  end

  def dodaj_krawedz(miasto_docelowe, zapach=0.2)
    if @krawedzie[miasto_docelowe.nazwa] == nil
      @krawedzie[miasto_docelowe.nazwa] = Krawedz.new(miasto_docelowe, zapach)
      @sasiedzi.add(miasto_docelowe)
    end

    @krawedzie[miasto_docelowe.nazwa]
  end

  def to_s
    @nazwa
  end

  attr_accessor :nazwa, :krawedzie, :sasiedzi
end