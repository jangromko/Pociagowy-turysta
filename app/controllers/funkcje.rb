def sigmoidalna_koszt(x)
  1-1/(1+Math.exp((-x+40000)*0.0005))

  #1000/x
end

def sigmoidalna_rozmiar(x)
  1-1/(1+Math.exp((-x+110)*0.5))
end

def atrakcyjnosc_czekanie(x)
  1-1/(1+Math.exp((-x+30)*0.06))+1/(x+0.1)

  #1/(x+0.1)
end

def atrakcyjnosc_czas_podrozy(x)
  1-1/(1+Math.exp((-x)*0.005))

  1/(x+0.1)
end

def nieodwiedzeni_atrakcyjnosc(x)
=begin
  if x == 0
    0.001
  elsif x == 1
    0.03
  elsif x > 1 and x < 10
    Math.log(x)/10
  else
    Math.exp((x-100)*0.03)+0.16
  end
=end

  if x >= 1
    1
  else
    0.3
  end
end

def dodaj_do_czasu(obecny_czas, dodane)
  (obecny_czas + dodane)%1440
end

def wylicz_czas_polaczenia(obecny_czas, odjazd, czas_trwania)
  if odjazd >= obecny_czas
    wynik = odjazd - obecny_czas
  else
    wynik = 1440 - obecny_czas + odjazd
  end


  wynik+czas_trwania
end

def roznica_czasu(od_kiedy, do_kiedy)
  if do_kiedy >= od_kiedy
    do_kiedy - od_kiedy
  else
    1440 - od_kiedy + do_kiedy
  end
end

WSP = {"Augustów" => {"lat" => 53.84344309999999, "lng" => 22.9796023}, "Biała Podlaska" => {"lat" => 52.0387126, "lng" => 23.1445026}, "Białystok" => {"lat" => 53.13248859999999, "lng" => 23.1688403}, "Bielsk Podlaski" => {"lat" => 52.7650576, "lng" => 23.1867524}, "Bielsko-Biała" => {"lat" => 49.8223768, "lng" => 19.0583845}, "Bochnia" => {"lat" => 49.96845769999999, "lng" => 20.4303285}, "Brodnica" => {"lat" => 53.2599703, "lng" => 19.3956618}, "Brzeg" => {"lat" => 50.8608509, "lng" => 17.4668311}, "Bydgoszcz" => {"lat" => 53.12348040000001, "lng" => 18.0084378}, "Chełm" => {"lat" => 51.1431232, "lng" => 23.4711986}, "Chojnice" => {"lat" => 53.6944002, "lng" => 17.5569252}, "Ciechanów" => {"lat" => 52.8814838, "lng" => 20.6197948}, "Częstochowa" => {"lat" => 50.8118195, "lng" => 19.1203094}, "Dębica" => {"lat" => 50.0516417, "lng" => 21.4116964}, "Elbląg" => {"lat" => 54.1560613, "lng" => 19.4044897}, "Ełk" => {"lat" => 53.8280529, "lng" => 22.3646629}, "Gdańsk" => {"lat" => 54.35202520000001, "lng" => 18.6466384}, "Gdynia" => {"lat" => 54.5188898, "lng" => 18.5305409}, "Gliwice" => {"lat" => 50.29449229999999, "lng" => 18.6713802}, "Gniezno" => {"lat" => 52.5349253, "lng" => 17.5826575}, "Gorzów Wielkopolski" => {"lat" => 52.7325285, "lng" => 15.2369305}, "Grajewo" => {"lat" => 53.64715589999999, "lng" => 22.455217}, "Grudziądz" => {"lat" => 53.4837486, "lng" => 18.753565}, "Głogów" => {"lat" => 51.66358520000001, "lng" => 16.0846672}, "Inowrocław" => {"lat" => 52.7993317, "lng" => 18.2562032}, "Iława" => {"lat" => 53.5959811, "lng" => 19.5684104}, "Jarosław" => {"lat" => 50.0161463, "lng" => 22.6777169}, "Jelenia Góra" => {"lat" => 50.9044171, "lng" => 15.7193616}, "Kalisz" => {"lat" => 51.76727990000001, "lng" => 18.0853462}, "Katowice" => {"lat" => 50.26489189999999, "lng" => 19.0237815}, "Kielce" => {"lat" => 50.8660773, "lng" => 20.6285677}, "Kluczbork" => {"lat" => 50.97235, "lng" => 18.21807}, "Konin" => {"lat" => 52.2230334, "lng" => 18.2510729}, "Kostrzyn" => {"lat" => 52.58718890000001, "lng" => 14.6494467}, "Koszalin" => {"lat" => 54.1943219, "lng" => 16.1714908}, "Kołobrzeg" => {"lat" => 54.17591729999999, "lng" => 15.5832667}, "Kraków" => {"lat" => 50.06465009999999, "lng" => 19.9449799}, "Kędzierzyn-Koźle" => {"lat" => 50.3498805, "lng" => 18.2261844}, "Kłodzko" => {"lat" => 50.4345636, "lng" => 16.6613941}, "Legionowo" => {"lat" => 52.4044483, "lng" => 20.9499697}, "Legnica" => {"lat" => 51.2070067, "lng" => 16.1553231}, "Leszno" => {"lat" => 51.8419861, "lng" => 16.5937545}, "Lublin" => {"lat" => 51.2464536, "lng" => 22.5684463}, "Malbork" => {"lat" => 54.0361319, "lng" => 19.0379763}, "Namysłów" => {"lat" => 51.07588, "lng" => 17.72244}, "Nowy Sącz" => {"lat" => 49.6174535, "lng" => 20.7153326}, "Nysa" => {"lat" => 50.4822855, "lng" => 17.3295861}, "Olsztyn" => {"lat" => 53.778422, "lng" => 20.4801193}, "Opole" => {"lat" => 50.6751067, "lng" => 17.9212976}, "Ostrowiec Świętokrzyski" => {"lat" => 50.9295234, "lng" => 21.3851915}, "Ostrołęka" => {"lat" => 53.0876544, "lng" => 21.5592554}, "Ostróda" => {"lat" => 53.69630069999999, "lng" => 19.9647952}, "Oświęcim" => {"lat" => 50.0343982, "lng" => 19.2097782}, "Pabianice" => {"lat" => 51.6567303, "lng" => 19.35776}, "Piotrków Trybunalski" => {"lat" => 51.40517209999999, "lng" => 19.7030244}, "Piła" => {"lat" => 53.1509671, "lng" => 16.7382266}, "Poznań" => {"lat" => 52.406374, "lng" => 16.9251681}, "Pruszków" => {"lat" => 52.1704725, "lng" => 20.8118862}, "Przemyśl" => {"lat" => 49.7838623, "lng" => 22.7677908}, "Puławy" => {"lat" => 51.4164431, "lng" => 21.969309}, "Radom" => {"lat" => 51.40272359999999, "lng" => 21.1471333}, "Radomsko" => {"lat" => 51.0668544, "lng" => 19.4449387}, "Rybnik" => {"lat" => 50.1021742, "lng" => 18.5462847}, "Rzeszów" => {"lat" => 50.0411867, "lng" => 21.9991196}, "Siedlce" => {"lat" => 52.1676031, "lng" => 22.2901645}, "Sieradz" => {"lat" => 51.5956014, "lng" => 18.7302994}, "Skarżysko-Kamienna" => {"lat" => 51.114294, "lng" => 20.8477827}, "Skierniewice" => {"lat" => 51.9547169, "lng" => 20.1583303}, "Sokółka" => {"lat" => 53.4061597, "lng" => 23.5030235}, "Sosnowiec" => {"lat" => 50.28626380000001, "lng" => 19.1040791}, "Stalowa Wola" => {"lat" => 50.5826005, "lng" => 22.053586}, "Starachowice" => {"lat" => 51.0368289, "lng" => 21.0709769}, "Stargard" => {"lat" => 53.3364746, "lng" => 15.0503771}, "Starogard Gdański" => {"lat" => 53.965614, "lng" => 18.5162736}, "Suwałki" => {"lat" => 54.1115218, "lng" => 22.9307881}, "Szczecin" => {"lat" => 53.4285438, "lng" => 14.5528116}, "Szczecinek" => {"lat" => 53.7100713, "lng" => 16.6993602}, "Szczytno" => {"lat" => 53.56354, "lng" => 20.99519}, "Słupsk" => {"lat" => 54.46414799999999, "lng" => 17.0284824}, "Tarnobrzeg" => {"lat" => 50.5729079, "lng" => 21.6790698}, "Tarnów" => {"lat" => 50.0121011, "lng" => 20.9858407}, "Tczew" => {"lat" => 54.0919269, "lng" => 18.7773072}, "Toruń" => {"lat" => 53.0137902, "lng" => 18.5984437}, "Warszawa" => {"lat" => 52.2296756, "lng" => 21.0122287}, "Wałbrzych" => {"lat" => 50.7840092, "lng" => 16.2843553}, "Wrocław" => {"lat" => 51.1078852, "lng" => 17.0385376}, "Włocławek" => {"lat" => 52.6483303, "lng" => 19.0677357}, "Włoszczowa" => {"lat" => 50.8312787, "lng" => 19.9357582}, "Zakopane" => {"lat" => 49.299181, "lng" => 19.9495621}, "Zamość" => {"lat" => 50.7230879, "lng" => 23.2519686}, "Zielona Góra" => {"lat" => 51.9356214, "lng" => 15.5061862}, "Jędrzejów" => {"lat" => 50.65754, "lng" => 20.3008653}, "Łuków" => {"lat" => 51.927158, "lng" => 22.3830241}, "Łódź" => {"lat" => 51.7592485, "lng" => 19.4559833}, "Świdnica" => {"lat" => 50.8498434, "lng" => 16.475679}, "Świnoujście" => {"lat" => 53.9100327, "lng" => 14.2475775}, "Świebodzin" => {"lat" => 52.2443924, "lng" => 15.4559135}, "Żagań" => {"lat" => 51.6178445, "lng" => 15.3248325}, "Żary" => {"lat" => 51.6420121, "lng" => 15.1369992}}
