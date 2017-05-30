load 'polaczenie.rb'


class Krawedz
  def initialize(miasto_docelowe, zapach=0.5)
    @miasto_docelowe = miasto_docelowe
    @zapach = zapach + rand(0.0..0.03)
    @polaczenia = []
  end

  def dodaj_polaczenie(polaczenie)
    @polaczenia.push(polaczenie)
  end

  def najlepsze_polaczenie(obecny_czas)
    najlepsze = nil
    najlepszy_czas = 20000

    @polaczenia.each do |polaczenie|
      czas = wylicz_czas_polaczenia(obecny_czas, polaczenie.odjazd, polaczenie.czas)
      if czas < najlepszy_czas
        najlepsze = polaczenie
        najlepszy_czas = czas
      end
    end

    najlepsze
  end

  def to_s
    'miasto docelowe: ' + @miasto_docelowe.to_s + ', zapach: ' + @zapach.to_s
  end

  def odparuj(wspolczynnik)
    @zapach = @zapach * (1 - wspolczynnik)
  end

  def dodaj_feromon(ilosc, wspolczynnik=1)
    @zapach += ilosc*wspolczynnik
  end

  def to_map
    {'miasto_docelowe' => @miasto_docelowe.nazwa, 'zapach' => @zapach}
  end

  attr_reader :miasto_docelowe, :zapach, :polaczenia
end