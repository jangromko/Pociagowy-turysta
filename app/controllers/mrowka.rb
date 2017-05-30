require 'set'
load 'trasa.rb'

class Mrowka

  def initialize(start, rozmiar_grafu, graf)
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
    @aktualny_czas = rand(0..1439)
    # @aktualny_czas = 0
    @r = Random.new
    @trasa_bufor = Trasa.new


    @wierzcholki = []
    @sasiedzi_do_odwiedzenia = {}
    graf.wierzcholki.each_key do |w|
      @wierzcholki.push(graf.wierzcholki[w])
      @sasiedzi_do_odwiedzenia[w] = graf.wierzcholki[w].sasiedzi.size
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
          dodatek_na_przesiadke = 1
        elsif @odwiedzone.size == 1
          dodatek_na_przesiadke = 0
        else
          dodatek_na_przesiadke = 25
        end
        # atrakcyjnosc *= (10000.0/(ile_czekania(dodaj_do_czasu(@aktualny_czas, dodatek_na_przesiadke), krawedz.odjazd) + 0.001))**2
        # atrakcyjnosc *= 100.0/(polaczenie.czas + 0.01)
        atrakcyjnosc *= atrakcyjnosc_czas_podrozy(polaczenie.czas)
        atrakcyjnosc *= atrakcyjnosc_czekanie(ile_czekania(dodaj_do_czasu(@aktualny_czas, dodatek_na_przesiadke), polaczenie.odjazd))

        if @odwiedzone.include?(polaczenie.miasto_docelowe)
          atrakcyjnosc /= 10**5
        else
        end

        # atrakcyjnosc *= nieodwiedzeni_atrakcyjnosc(@sasiedzi_do_odwiedzenia[polaczenie.miasto_docelowe.nazwa])

        if polaczenie.miasto_docelowe == @obecny_wierzcholek
          atrakcyjnosc /= 1000.0
        end


        suma_atrakcyjnosci += atrakcyjnosc
        kandydaci[polaczenie] = atrakcyjnosc
      end


      wybor = @r.rand(0.0..suma_atrakcyjnosci)
      suma_pom = 0
=begin
      puts @obecny_wierzcholek

      kandydaci.each_key do |k|
        puts k
      end

      puts '–––––––––––––––––––––––––'
=end

      kandydaci.each_key do |kandydat|
        suma_pom += kandydaci[kandydat]
        if suma_pom >= wybor
          if kandydat.stacja_poczatkowa == @obecna_stacja
            dodatek_na_przesiadke = 1
          elsif @odwiedzone.size == 1
            dodatek_na_przesiadke = 0
          else
            dodatek_na_przesiadke = 25
          end

          # @trasa_ogolna.push(@graf.wierzcholki[@obecny_wierzcholek.nazwa].krawedzie[kandydat.miasto_docelowe.nazwa])
          # @trasa.dolacz_krawedz(@graf.wierzcholki[@obecny_wierzcholek.nazwa].krawedzie[kandydat.miasto_docelowe.nazwa], kandydat)
          @trasa_bufor.dolacz_krawedz(@graf.wierzcholki[@obecny_wierzcholek.nazwa].krawedzie[kandydat.miasto_docelowe.nazwa], kandydat)

          @aktualny_czas = dodaj_do_czasu(@aktualny_czas, dodatek_na_przesiadke)
          @obecny_wierzcholek = kandydat.miasto_docelowe

          @wierzcholki.each do |w|
            if w.sasiedzi.include? @obecny_wierzcholek and !(@odwiedzone.include? @obecny_wierzcholek)
              @sasiedzi_do_odwiedzenia[w.nazwa] -= 1
            end
          end

          @obecna_stacja = kandydat.stacja_docelowa
          # @trasa.push(kandydat)
          @koszt += kandydat.czas + ile_czekania(@aktualny_czas, kandydat.odjazd)
          @aktualny_czas = (@aktualny_czas + ile_czekania(@aktualny_czas, kandydat.odjazd) + kandydat.czas)%1440
          unless @odwiedzone.include? @obecny_wierzcholek
            @koszt += 30
            @aktualny_czas = (@aktualny_czas + 30)%1440


            if @trasa_bufor.trasa_szczegoly.size == 1
              @trasa.dolacz_trase(@trasa_bufor)
              @trasa_bufor.wyczysc
            else
              @trasa.dolacz_trase(@trasa_bufor)
              @trasa_bufor.wyczysc
=begin
              buf_start = @trasa.trasa_szczegoly.last.miasto_docelowe
              puts buf_start
              puts @trasa_bufor.trasa_szczegoly


              for i in (@trasa_bufor.trasa_szczegoly.size-2).downto 0
                #puts i
                #puts @trasa_bufor.trasa_szczegoly[i]

                if buf_start == @trasa_bufor.trasa_szczegoly[i].miasto_docelowe
                  #puts 'HEJOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO'
                  skrot = Trasa.new

                  krawedz = @graf.wierzcholki[buf_start.nazwa].krawedzie[@trasa_bufor.trasa_szczegoly[i+1].miasto_docelowe.nazwa]
                  skrot.dolacz_polaczenie(krawedz.najlepsze_polaczenie(@trasa.trasa_szczegoly.last.przyjazd+30))


                  for j in (i+2)..@trasa_bufor.trasa_szczegoly.size-1
                    skrot.dolacz_polaczenie(@graf.najlepsze_polaczenie(skrot.trasa_szczegoly.last.miasto_docelowe.nazwa, @trasa_bufor.trasa_szczegoly[j].miasto_docelowe.nazwa, skrot.trasa_szczegoly.last.przyjazd+1))
                  end

                  @trasa_bufor = skrot

                  break
                end
=end
              end

=begin
              puts '~~~~'
              puts @trasa_bufor.trasa_szczegoly

              lista_miast = @trasa_bufor.lista_miast

              for x in 0..lista_miast.size-2
                for y in x+2..(lista_miast.size-1)

                  #puts lista_miast[x].nazwa + '––' + lista_miast[y].nazwa
                  if lista_miast[x] == lista_miast[y] or !lista_miast[x].krawedzie[lista_miast[y]].nil?
                    for z in y.downto x+1
                      lista_miast.delete_at(z)
                    end

                    break
                  end
                end
              end



              #puts '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
              #puts lista_miast
              #puts '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'

              skrot = Trasa.new
              puts @trasa.trasa_szczegoly.last.miasto_docelowe.krawedzie[lista_miast[0].nazwa].nil?
              puts @trasa.trasa_szczegoly.last.miasto_docelowe.nazwa + '----' + lista_miast[0].nazwa
              skrot.dolacz_polaczenie(@graf.najlepsze_polaczenie(@trasa.trasa_szczegoly.last.miasto_docelowe.nazwa, lista_miast[0].nazwa, @trasa.trasa_szczegoly.last.przyjazd+30))



              puts lista_miast

              for x in 1..lista_miast.size-2
                if lista_miast[x].nazwa != lista_miast[x+1].nazwa

                  skrot.dolacz_polaczenie(@graf.najlepsze_polaczenie(lista_miast[x].nazwa, lista_miast[x+1].nazwa, skrot.trasa_szczegoly.last.przyjazd+1))
                end
              end


              @trasa.dolacz_trase(skrot)
              @trasa_bufor.wyczysc

              puts '––––––––––––––––'


            end
=end
          end
          @odwiedzone.add(@obecny_wierzcholek)
          # puts @obecny_wierzcholek.nazwa
          break
        end
      end

    elsif @odwiedzone.size >= @rozmiar_grafu and @obecny_wierzcholek == @start
      @status = 1
    else

      @obecny_wierzcholek.krawedzie.each_key do |krawedz|
        # atrakcyjnosc = @obecny_wierzcholek.krawedzie[krawedz].zapach
        atrakcyjnosc = 1.0
        if @obecny_wierzcholek.krawedzie[krawedz].miasto_docelowe == @start
          atrakcyjnosc *= 500.0
        end

        if @obecny_wierzcholek.krawedzie[krawedz].miasto_docelowe == @obecny_wierzcholek
          atrakcyjnosc /= 100.0
        end

        suma_atrakcyjnosci += atrakcyjnosc
        kandydaci[@obecny_wierzcholek.krawedzie[krawedz].najlepsze_polaczenie(@aktualny_czas)] = atrakcyjnosc
      end


      wybor = @r.rand(0.0..suma_atrakcyjnosci)
      suma_pom = 0

=begin
      puts @obecny_wierzcholek

      kandydaci.each_key do |k|
        puts k
      end

      puts '–––––––––––––––––––––––––'

=end

      kandydaci.each_key do |kandydat|
        suma_pom += kandydaci[kandydat]
        if suma_pom >= wybor
          if kandydat.stacja_docelowa == @obecna_stacja
            dodatek_na_przesiadke = 1
          elsif @odwiedzone.size == 1
            dodatek_na_przesiadke = 0
          else
            dodatek_na_przesiadke = 25
          end

          if @trasa_bufor.trasa_szczegoly.size == 1
            @trasa.dolacz_trase(@trasa_bufor)
            @trasa_bufor.wyczysc
          else
            @trasa.dolacz_trase(@trasa_bufor)
            @trasa_bufor.wyczysc
          end

          @trasa.dolacz_krawedz_powrotna(@graf.wierzcholki[@obecny_wierzcholek.nazwa].krawedzie[kandydat.miasto_docelowe.nazwa], kandydat)
          # @trasa_ogolna.push(@graf.wierzcholki[@obecny_wierzcholek.nazwa].krawedzie[kandydat.miasto_docelowe.nazwa])
          @obecny_wierzcholek = kandydat.miasto_docelowe
          @obecna_stacja = kandydat.stacja_docelowa
          # @trasa.push(kandydat)
          @koszt += kandydat.czas + ile_czekania(dodaj_do_czasu(@aktualny_czas, dodatek_na_przesiadke), kandydat.odjazd)
          @aktualny_czas = (@aktualny_czas + ile_czekania(@aktualny_czas, kandydat.odjazd) + kandydat.czas)%1440
          break
        end
      end
    end
  end


  def wykonaj_pelna_trase
    until @status == 1
      idz_dalej
      #puts @sasiedzi_do_odwiedzenia.to_s
    end

    if @trasa_bufor.trasa_szczegoly.size == 1
      @trasa.dolacz_trase(@trasa_bufor)
      @trasa_bufor.wyczysc
    else
      @trasa.dolacz_trase(@trasa_bufor)
      @trasa_bufor.wyczysc
    end

    @koszt = @trasa.wylicz_czas(@trasa.trasa_szczegoly[0].odjazd, 0, @trasa.trasa_szczegoly.size-1)
  end


  attr_reader :obecny_wierzcholek, :trasa, :odwiedzone, :koszt
end