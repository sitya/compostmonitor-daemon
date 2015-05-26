# Komposztmonitor kliens
Ez egy terminál alapú alkalmazás, amely a RaspberryPI-hez csatlakoztatott DS18B20-as hőmérséklet-, vagy DHT22-es típusú hőmérséklet- és páraérzékelőkből kiolvassa a hőmérsékleti értékeket és feltölti őket a szerverre. A **szerver** innen tölthető le: https://github.com/sitya/compostmonitor-server.git

## Telepítés és beállítás

1. `cd /var`
2. `sudo git clone https://github.com/sitya/compostmonitor-daemon.git`
3. `sudo chown -R pi compostmonitor-daemon` // Itt a `pi` helyére a RPi-n használt felhasználónév irandó
4. `cd compostmonitor-daemon`
5. `mkdir logs proc`

### Szenzoradatok rögzítése

A formátum a következő: típus:azonosító:név. A típus háromféle lehet: 

* c - komposztkazánhoz tartozó hőmérsékleti szenzor
* i - belső lakótér hőmérsékleti szenzor
* o - külső levegő hőmérsékleti szenzor

**DS18B20**
Szerkessz egy `conf.d/ds18b20` nevű fájlt az alábbi minta alapján
```
c|28-0000054c0051: Komposztkazán előremenő ág
c|28-0000054c0052: Komposztkazán visszatérő ág
c|28-0000054c0053: Komposztkazán maghőmérséklet
i|28-0000054c0054: Előszoba
i|28-0000054c0055: Nappali
o|28-0000054c0056: Külső hőmérséklet
```
**DHT22**
Ha van ilyen érzékelőd, szerkessz egy `conf.d/dht` nevű fájlt az alábbi minta alapján. Az egy-egy sorban szereplő számjegy az RPi GPIO azon lábazonosítóját adja meg, melyre a DHT érzékelő jelvezetéke rá lett kötve.
```
i|17: fürdőszoba
i|18: gyerekszoba
```

Ha kész vagy, futtasd a konfigfeltöltő szkriptet: `bin/push-config-to-ui.sh`

### Szerverkapcsolódási paraméterek

A `main.conf`-ban állítsd be a szerver címét és a kapcsolódáshoz használt felhasználói nevet és jelszót. Ha ezeket módosítod, akkor szerveroldalon is módosítani kell!

### Időzített futtatás
Ezek után már csak az időzített futtatást kell beállítani. Az alábbi két sort vedd fel a `crontab`-ba.

```bash
# Komposztkazan adatrogzites
*/5 * * * * /var/compostmonitor-daemon/bin/main.sh

# Komposztkazan adatfeltoltes
*/10 * * * * /var/compostmonitor-daemon/bin/push.sh
```

Előbb-utóbb meg fognak jelenni a szerveroldali grafikonon az adatsorok.
