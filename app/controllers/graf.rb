load 'wierzcholek.rb'

class Graf
  def initialize
    @wierzcholki = {}
  end

  def dodaj_wierzcholek(wierzcholek)
    @wierzcholki[wierzcholek.nazwa] = wierzcholek
  end

  def utworz_z_jsona(rozklad)
    rozklad.each_key do |miasto|
      if miasto == 'Olkusz'
        next
      end

      self.dodaj_wierzcholek(Wierzcholek.new(miasto))
    end

    rozklad.each_key do |miasto|
      if miasto == 'Olkusz'
        next
      end

      w = @wierzcholki[miasto]

      rozklad[miasto].each_key do |stacja|
        rozklad[miasto][stacja].each do |polaczenie|
          polaczenie['stacje'].each do |cel|
            # w.dodaj_krawedz(cel['czas'], polaczenie['odjazd'], cel['przyjazd'], stacja, @wierzcholki[cel['miastoDocelowe']], cel['stacjaDocelowa'], polaczenie['pociag'])
            krawedz = w.dodaj_krawedz(@wierzcholki[cel['miastoDocelowe']])
            krawedz.dodaj_polaczenie(Polaczenie.new(cel['czas'], polaczenie['odjazd'], cel['przyjazd'], stacja, cel['stacjaDocelowa'], polaczenie['pociag'], @wierzcholki[cel['miastoDocelowe']]))
          end
        end
      end
    end
  end

  def wierzcholek_nazwa(nazwa)
    @wierzcholki[nazwa]
  end

  def odparuj(wspolczynnik=0.2)
    @wierzcholki.each_key do |wierzcholek|
      @wierzcholki[wierzcholek].krawedzie.each_key do |krawedz|
        @wierzcholki[wierzcholek].krawedzie[krawedz].odparuj(wspolczynnik)
      end
    end
  end


  def najlepsze_polaczenie(skad, dokad, czas_start)
    @wierzcholki[skad].krawedzie[dokad].najlepsze_polaczenie(czas_start)
  end

  attr_accessor :wierzcholki
end