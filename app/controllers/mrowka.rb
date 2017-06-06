require 'set'
load 'trasa.rb'

class Mrowka

  def initialize(start, rozmiar_grafu, graf, czas_zwiedzania, przesiadka, inna_stacja, czas_start=rand(0..1439))
    @start = start
    # @trasa = []
    # @trasa_ogolna = []
    @trasa = Trasa.new
    @odwiedzone = Set.new [start]
    @obecny_wierzcholek = start
    @obecna_stacja = nil
    @rozmiar_grafu = rozmiar_grafu
    @status = 0
    @koszt = 0
    @graf = graf
    @aktualny_czas = czas_start
    @trasa_ogolna = []
    # @aktualny_czas = 0
    @r = Random.new
    @trasa_bufor = Trasa.new
    @czas_zwiedzania = czas_zwiedzania
    @przesiadka = przesiadka
    @przesiadka_inna_stacja = inna_stacja


    @wierzcholki = []
    @sasiedzi_do_odwiedzenia = {}
    graf.wierzcholki.each_key do |w|
      @wierzcholki.push(graf.wierzcholki[w])
      #@sasiedzi_do_odwiedzenia[w] = graf.wierzcholki[w].sasiedzi.size
    end
  end


  def ile_czekania(obecny_czas, odjazd)
    if obecny_czas <= odjazd
      odjazd - obecny_czas
    else
      1440 - obecny_czas + odjazd
    end
  end


  def idz_dalej
    kandydaci = {}
    suma_atrakcyjnosci = 0
    if @odwiedzone.size < @rozmiar_grafu
      @obecny_wierzcholek.krawedzie.each_key do |krawedz|
        atrakcyjnosc = @obecny_wierzcholek.krawedzie[krawedz].zapach
        polaczenie = @obecny_wierzcholek.krawedzie[krawedz].najlepsze_polaczenie(@aktualny_czas)

        if polaczenie.stacja_poczatkowa == @obecna_stacja
          dodatek_na_przesiadke = @przesiadka
        elsif @odwiedzone.size == 1
          dodatek_na_przesiadke = 0
        else
          dodatek_na_przesiadke = @przesiadka_inna_stacja
        end

        atrakcyjnosc *= atrakcyjnosc_czas_podrozy(polaczenie.czas)
        atrakcyjnosc *= atrakcyjnosc_czekanie(ile_czekania(dodaj_do_czasu(@aktualny_czas, dodatek_na_przesiadke), polaczenie.odjazd))

        if @odwiedzone.include?(polaczenie.miasto_docelowe)
          atrakcyjnosc /= 10**5
        else
        end


        if polaczenie.miasto_docelowe == @obecny_wierzcholek
          atrakcyjnosc /= 1000.0
        end


        suma_atrakcyjnosci += atrakcyjnosc
        kandydaci[polaczenie] = atrakcyjnosc
      end


      wybor = @r.rand(0.0..suma_atrakcyjnosci)
      suma_pom = 0


      kandydaci.each_key do |kandydat|
        suma_pom += kandydaci[kandydat]
        if suma_pom >= wybor
          if kandydat.stacja_poczatkowa == @obecna_stacja
            dodatek_na_przesiadke = @przesiadka
          elsif @odwiedzone.size == 1
            dodatek_na_przesiadke = 0
          else
            dodatek_na_przesiadke = @przesiadka_inna_stacja
          end

          @trasa_bufor.dolacz_krawedz(@graf.wierzcholki[@obecny_wierzcholek.nazwa].krawedzie[kandydat.miasto_docelowe.nazwa], kandydat)

          @aktualny_czas = dodaj_do_czasu(@aktualny_czas, dodatek_na_przesiadke)
          @obecny_wierzcholek = kandydat.miasto_docelowe

          @obecna_stacja = kandydat.stacja_docelowa
          # @koszt += kandydat.czas + ile_czekania(@aktualny_czas, kandydat.odjazd)
          @aktualny_czas = (@aktualny_czas + ile_czekania(@aktualny_czas, kandydat.odjazd) + kandydat.czas)%1440
          unless @odwiedzone.include? @obecny_wierzcholek
            # @koszt += @czas_zwiedzania
            @aktualny_czas = (@aktualny_czas + @czas_zwiedzania)%1440


            if @trasa_bufor.trasa_szczegoly.size <= 1
              @trasa.dolacz_trase(@trasa_bufor)
              @trasa_bufor.wyczysc
            else
              buf_start = @trasa.trasa_szczegoly.last.miasto_docelowe

              for i in (@trasa_bufor.trasa_szczegoly.size-2).downto 0

                if buf_start == @trasa_bufor.trasa_szczegoly[i].miasto_docelowe
                  skrot = Trasa.new

                  krawedz = @graf.wierzcholki[buf_start.nazwa].krawedzie[@trasa_bufor.trasa_szczegoly[i+1].miasto_docelowe.nazwa]
                  skrot.dolacz_polaczenie(krawedz.najlepsze_polaczenie(dodaj_do_czasu(@trasa.trasa_szczegoly.last.przyjazd, @czas_zwiedzania)))


                  for j in (i+2)..@trasa_bufor.trasa_szczegoly.size-1
                    skrot.dolacz_polaczenie(@graf.najlepsze_polaczenie(skrot.trasa_szczegoly.last.miasto_docelowe.nazwa, @trasa_bufor.trasa_szczegoly[j].miasto_docelowe.nazwa, dodaj_do_czasu(skrot.trasa_szczegoly.last.przyjazd, @przesiadka)))

                    if skrot.trasa_szczegoly.last.stacja_poczatkowa != skrot.trasa_szczegoly[skrot.trasa_szczegoly.size-2].stacja_docelowa and skrot.trasa_szczegoly.last.odjazd < dodaj_do_czasu(skrot.trasa_szczegoly[skrot.trasa_szczegoly.size-2].przyjazd, @przesiadka_inna_stacja)
                      skrot.trasa_szczegoly[skrot.trasa_szczegoly.size-1] = @graf.najlepsze_polaczenie(skrot.trasa_szczegoly[skrot.trasa_szczegoly.size-2].miasto_docelowe.nazwa, skrot.trasa_szczegoly.last.miasto_docelowe.nazwa, dodaj_do_czasu(skrot.trasa_szczegoly.last.odjazd, 1))

                      if skrot.trasa_szczegoly.last.stacja_poczatkowa != skrot.trasa_szczegoly[skrot.trasa_szczegoly.size-2].stacja_docelowa and skrot.trasa_szczegoly.last.odjazd < dodaj_do_czasu(skrot.trasa_szczegoly[skrot.trasa_szczegoly.size-2].przyjazd, @przesiadka_inna_stacja)
                        skrot.trasa_szczegoly[skrot.trasa_szczegoly.size-1] = @graf.najlepsze_polaczenie(skrot.trasa_szczegoly[skrot.trasa_szczegoly.size-2].miasto_docelowe.nazwa, skrot.trasa_szczegoly.last.miasto_docelowe.nazwa, dodaj_do_czasu(skrot.trasa_szczegoly[skrot.trasa_szczegoly.size-2].przyjazd, @przesiadka_inna_stacja))
                      end

                    end
                  end

                  @trasa_bufor = skrot

                  break
                end
              end


              for i in 0..@trasa_bufor.trasa_szczegoly.size-1
                j = @trasa_bufor.trasa_szczegoly.size-1
                while j >= i
                  if @trasa_bufor.trasa_szczegoly[i].miasto_docelowe == @trasa_bufor.trasa_szczegoly[j].miasto_docelowe
                    for k in 0..(j-i-1)
                      @trasa_bufor.trasa_szczegoly.delete_at(i+1)
                      j -= 1
                    end
                  end

                  j -= 1
                end
              end

              for i in 0..@trasa_bufor.trasa_szczegoly.size-1
                j = @trasa_bufor.trasa_szczegoly.size-1
                while j > i+1
                  if @trasa_bufor.trasa_szczegoly[i].miasto_docelowe.sasiedzi.include? @trasa_bufor.trasa_szczegoly[j].miasto_docelowe
                    for k in 0..(j-i-2)
                      @trasa_bufor.trasa_szczegoly.delete_at(i+1)
                      j -= 1
                    end

                    @trasa_bufor.trasa_szczegoly[i+1] = @trasa_bufor.trasa_szczegoly[i].miasto_docelowe.krawedzie[@trasa_bufor.trasa_szczegoly[i+1].miasto_docelowe.nazwa].najlepsze_polaczenie(@trasa_bufor.trasa_szczegoly[i].przyjazd + 1)

                    if @trasa_bufor.trasa_szczegoly[i+1].stacja_poczatkowa != @trasa_bufor.trasa_szczegoly[i].stacja_docelowa and @trasa_bufor.trasa_szczegoly[i+1].odjazd < dodaj_do_czasu(@trasa_bufor.trasa_szczegoly[i].przyjazd, @przesiadka_inna_stacja)
                      @trasa_bufor.trasa_szczegoly[i+1] = @graf.najlepsze_polaczenie(@trasa_bufor.trasa_szczegoly[i].miasto_docelowe.nazwa, @trasa_bufor.trasa_szczegoly[i+1].miasto_docelowe.nazwa, dodaj_do_czasu(@trasa_bufor.trasa_szczegoly[i+1].odjazd, 1))

                      if @trasa_bufor.trasa_szczegoly[i+1].stacja_poczatkowa != @trasa_bufor.trasa_szczegoly[i].stacja_docelowa and @trasa_bufor.trasa_szczegoly[i+1].odjazd < dodaj_do_czasu(@trasa_bufor.trasa_szczegoly[i].przyjazd, @przesiadka_inna_stacja)
                        @trasa_bufor.trasa_szczegoly[i+1] = @graf.najlepsze_polaczenie(@trasa_bufor.trasa_szczegoly[i].miasto_docelowe.nazwa, @trasa_bufor.trasa_szczegoly[i+1].miasto_docelowe.nazwa, dodaj_do_czasu(@trasa_bufor.trasa_szczegoly[i].przyjazd, @przesiadka_inna_stacja))
                      end
                    end
                  end
                  j -= 1
                end
              end

              if @trasa.trasa_szczegoly.size > 0
                @trasa_bufor.trasa_szczegoly[0] = @graf.wierzcholki[@trasa.trasa_szczegoly.last.miasto_docelowe.nazwa].krawedzie[@trasa_bufor.trasa_szczegoly[0].miasto_docelowe.nazwa].najlepsze_polaczenie(@trasa.trasa_szczegoly.last.przyjazd+@czas_zwiedzania)
              end


              for i in 1..@trasa_bufor.trasa_szczegoly.size-1
                @trasa_bufor.trasa_szczegoly[i] = @graf.wierzcholki[@trasa_bufor.trasa_szczegoly[i-1].miasto_docelowe.nazwa].krawedzie[@trasa_bufor.trasa_szczegoly[i].miasto_docelowe.nazwa].najlepsze_polaczenie(@trasa_bufor.trasa_szczegoly[i-1].przyjazd+1)
              end


              @aktualny_czas = dodaj_do_czasu(@trasa_bufor.trasa_szczegoly.last.przyjazd, @czas_zwiedzania)

              @trasa.dolacz_trase(@trasa_bufor)
              @trasa_bufor.wyczysc
            end
          end
          @odwiedzone.add(@obecny_wierzcholek)
          break
        end
      end

    elsif @odwiedzone.size >= @rozmiar_grafu and @obecny_wierzcholek == @start
      @status = 1
    else

      @obecny_wierzcholek.krawedzie.each_key do |krawedz|

        polaczenie = @obecny_wierzcholek.krawedzie[krawedz].najlepsze_polaczenie(dodaj_do_czasu(@aktualny_czas, @przesiadka))
        atrakcyjnosc = 1.0
        if @obecny_wierzcholek.krawedzie[krawedz].miasto_docelowe == @start
          atrakcyjnosc *= 500.0
        elsif @obecny_wierzcholek.krawedzie[krawedz].miasto_docelowe.sasiedzi.include? @start
          atrakcyjnosc *= 200
        end

        if @obecny_wierzcholek.krawedzie[krawedz].miasto_docelowe == @obecny_wierzcholek
          atrakcyjnosc /= 100.0
        end

        atrakcyjnosc *= atrakcyjnosc_czas_podrozy(polaczenie.czas)

        suma_atrakcyjnosci += atrakcyjnosc
        kandydaci[polaczenie] = atrakcyjnosc
      end


      wybor = @r.rand(0.0..suma_atrakcyjnosci)
      suma_pom = 0


      kandydaci.each_key do |kandydat|
        suma_pom += kandydaci[kandydat]
        if suma_pom >= wybor
          @trasa_bufor.dolacz_krawedz_powrotna(@graf.wierzcholki[@obecny_wierzcholek.nazwa].krawedzie[kandydat.miasto_docelowe.nazwa], kandydat)
          @obecny_wierzcholek = kandydat.miasto_docelowe
          @obecna_stacja = kandydat.stacja_docelowa
          @aktualny_czas = (@aktualny_czas + ile_czekania(@aktualny_czas, kandydat.odjazd) + kandydat.czas)%1440
          break
        end
      end
    end
  end


  def wykonaj_pelna_trase
    until @status == 1
      idz_dalej

      if @trasa.trasa_szczegoly.size > 220
        @trasa.wyczysc
        @status = 2
        break
      end
    end

    if @status == 1
      if @trasa_bufor.powrotna_trasa_szczegoly.size == 1
        @trasa.dolacz_trase(@trasa_bufor)
      else
        for i in 0..@trasa_bufor.powrotna_trasa_szczegoly.size-1
          j = @trasa_bufor.powrotna_trasa_szczegoly.size-1
          while j >= i
            if @trasa_bufor.powrotna_trasa_szczegoly[i].miasto_docelowe == @trasa_bufor.powrotna_trasa_szczegoly[j].miasto_docelowe
              for k in 0..(j-i-1)
                @trasa_bufor.powrotna_trasa_szczegoly.delete_at(i+1)
                j -= 1
              end
            end

            j -= 1
          end
        end

        for i in 0..@trasa_bufor.powrotna_trasa_szczegoly.size-1
          j = @trasa_bufor.powrotna_trasa_szczegoly.size-1
          while j > i+1
            if @trasa_bufor.powrotna_trasa_szczegoly[i].miasto_docelowe.sasiedzi.include? @trasa_bufor.powrotna_trasa_szczegoly[j].miasto_docelowe
              for k in 0..(j-i-2)
                @trasa_bufor.powrotna_trasa_szczegoly.delete_at(i+1)
                j -= 1
              end

              @trasa_bufor.powrotna_trasa_szczegoly[i+1] = @trasa_bufor.powrotna_trasa_szczegoly[i].miasto_docelowe.krawedzie[@trasa_bufor.powrotna_trasa_szczegoly[i+1].miasto_docelowe.nazwa].najlepsze_polaczenie(@trasa_bufor.powrotna_trasa_szczegoly[i].przyjazd + 1)
            end

            j -= 1
          end
        end

        if @trasa_bufor.powrotna_trasa_szczegoly.size > 0
          @trasa_bufor.powrotna_trasa_szczegoly[0] = @graf.wierzcholki[@trasa.trasa_szczegoly.last.miasto_docelowe.nazwa].krawedzie[@trasa_bufor.powrotna_trasa_szczegoly[0].miasto_docelowe.nazwa].najlepsze_polaczenie(@trasa_bufor.powrotna_trasa_szczegoly[0].przyjazd+@czas_zwiedzania)
        end

        for i in 1..@trasa_bufor.trasa_szczegoly.size-1
          @trasa_bufor.powrotna_trasa_szczegoly[i] = @graf.wierzcholki[@trasa_bufor.powrotna_trasa_szczegoly[i-1].miasto_docelowe.nazwa].krawedzie[@trasa_bufor.powrotna_trasa_szczegoly[i].miasto_docelowe.nazwa].najlepsze_polaczenie(@trasa_bufor.powrotna_trasa_szczegoly[i-1].przyjazd+1)
        end

        @trasa.dolacz_trase(@trasa_bufor)
        @trasa_bufor.wyczysc
      end

      @koszt = @trasa.wylicz_czas_caly

    else
      @koszt = 1.0/0
    end
  end


  attr_reader :obecny_wierzcholek, :trasa, :odwiedzone, :koszt, :status
end