load 'funkcje.rb'

class Polaczenie
  def initialize(czas, odjazd, przyjazd, stacja_poczatkowa, stacja_docelowa, pociag, miasto_docelowe)
    @czas = czas
    @odjazd = odjazd
    @przyjazd = przyjazd
    @stacja_poczatkowa = stacja_poczatkowa
    @stacja_docelowa = stacja_docelowa
    @pociag = pociag
    @miasto_docelowe = miasto_docelowe
    @lat = WSP[@miasto_docelowe.nazwa]['lat']
    @lng = WSP[@miasto_docelowe.nazwa]['lng']
  end

  def to_s
    'miasto docelowe: ' + @miasto_docelowe.nazwa + ', czas: ' + @czas.to_s + ', odjazd: ' + @odjazd.to_s + ', przyjazd: ' + @przyjazd.to_s + ', stacja początkowa: ' + @stacja_poczatkowa + ', stacja docelowa: ' + @stacja_docelowa + ', pociąg: ' + @pociag
  end

  def to_map
    {'stacja_poczatkowa' => stacja_poczatkowa, 'stacja_docelowa' => @stacja_docelowa, 'miasto_docelowe' => @miasto_docelowe.nazwa, 'odjazd' => @odjazd, 'przyjazd' => @przyjazd, 'czas' => @czas, 'pociag' => @pociag, 'lat' => @lat, 'lng' => @lng}
  end


  attr_reader :czas, :odjazd, :przyjazd, :stacja_poczatkowa, :stacja_docelowa, :pociag, :miasto_docelowe
end