#
Aktuell funktioniert die Version 1.1.14 (Siehe im dortigen Branche)

# citigo

Kopplung des Skoda-Citigo eIv an die Wallboxsoftware OpenWB

Als Basis dient das Skodaconnect Module von https://github.com/lendy007/skodaconnect

**Installation**

Lege /var/www/html/lp1 mit Schreibrechte für alle an, also 0777

Lege /var/www/html/lp1/soc_citigo mit Schreibrechte für alle an, also 0777

kopiere falls es eine akutellere gibt den Unterorder skodakonnect aus lendy007/Skodaconnect Module dort hinein,
bei mir hab ich dann folgende Strucktur:
```
root@Hal3:/# ls -l /var/www/html/lp1/soc_citigo/skodaconnect/
insgesamt 260
-rwxr--r-- 1 root root  78331  5. Sep 18:30 connection.py
-rwxr--r-- 1 root root   8443  5. Sep 18:30 const.py
-rwxr--r-- 1 root root  31503  5. Sep 18:30 dashboard.py
-rwxr--r-- 1 root root   2940  5. Sep 18:30 exceptions.py
-rwxr--r-- 1 root root    289  5. Sep 18:30 __init__.py
-rwxr--r-- 1 root root   2565  5. Sep 18:30 utilities.py
-rwxr--r-- 1 root root 117301  5. Sep 18:30 vehicle.py
-rwxr--r-- 1 root root    226  5. Sep 18:30 __version__.py
root@Hal3:/#
```

Lege eine Config Datei dazu **var/www/html/lp1/soc_citigo/getsoc.conf**

Inhalt: 
```
# Accountdaten von myskoda
#
username:" xxxxx@xxxx.de"
password: "xxxxxxxxxx"
#

# Mindestabstand der abfragen
minold: 30

# Lasse carinfo schreiben (auf diesen Host)
#optc: --car
optc: ""

# host localhost oder externe openwb
mqtthost: 192.168.x.openWBIp
lp: 1

# lasse mqtt auch Skoda/# beschicken
#optmqtt: --MQTT
optmqtt: ""
```

Dann sieht das Verzeichniss soc_citigo insgesamt so aus:

```
var/www/html/lp1/soc_citigo:
-rwxrwxrwx 1 root     root     10736  3. Nov 13:15 callskoda.py
-rwxrwxrwx 1 root     root       296  3. Nov 21:48 getsoc.conf
-rwxrwxrwx 1 root     root       511  3. Nov 13:01 getsoc.sh
drwxrwxrwx 3 root     root      4096  3. Nov 10:51 skodaconnect

/var/www/html/lp1./soc_citigo/skodaconnect:
-rwxr--r-- 1 root root  78331  5. Sep 18:30 connection.py
-rwxr--r-- 1 root root   8443  5. Sep 18:30 const.py
-rwxr--r-- 1 root root  31503  5. Sep 18:30 dashboard.py
-rwxr--r-- 1 root root   2940  5. Sep 18:30 exceptions.py
-rwxr--r-- 1 root root    289  5. Sep 18:30 __init__.py
-rwxr--r-- 1 root root   2565  5. Sep 18:30 utilities.py
-rwxr--r-- 1 root root 117301  5. Sep 18:30 vehicle.py
-rwxr--r-- 1 root root    226  5. Sep 18:30 __version__.py
```

Jetzt kommt ein erster test

```
cd /var/www/html/lp1
./soc_citigo/getsoc.sh
```

Das sollte dann folgendes liefern

```
callskoda.py for LP1 debug:1
Init Skoda Connect library, version 1.1.4
Initiating new session to Skoda Connect with xxxx@xxx.de as username
Attempting to login to the Skoda Connect service
2021-11-03 21:54:40.989817
Login success!
2021-11-03 21:54:42.233216
Fetching vehicles associated with account.
connect to 192.168.xxx.openwbIP
Write to /openwb/lp/Skoda
Writing ../soc.txt
```

Anschliesend ist die folgenden Datei neu entstanden
```
/var/www/html/lp1/soc.txt
```

In der OpenWB ist nun ein HTTP SCO Module zu konfigurieren.

http://192.168.x.dieserHost/lp1/soc.php

Fertig.

Hinweis:
Lasst die Intervalle auf dem Defaultwert.
Da Script sollte nicht öfter als nötig aufgerufen werden.
ich habe bisher 60/5 (also 5 Minuten wenn angesteckt)
Dann dauert es längstes 10 Minuten bis die openWB den aktuellen Soc darstellt.
Auch bitte nicht auf dem "reload" rumdaddeln.
Das Script sollte sich nicht selbst überholen.

Es kann auch zu temporären Störungen auf den Servern der kommen.
Immer erst mal mit dem Handy testen ob der Skoda Server überhaupt "online" ist.

**Weitere Infos**

VW/SKoda/Seat ändern relativ häufig an ihrem Webauftritt und der jeweiligen PKW App herum.
Aktuell passiert es fast monatlich das am Skodaconnect Module nachgearbeitet werden muss.
In diesem Fall vom bitte ein Update beim orginal Autor herunterladen und das skodaconnect Verzeichnis
entsprechend aktualisieren. Im original Repositiory ist auch ein Beispiel-Script mit dem man
zuerst mal testen kann ob die Version für den Citigo überhaupt funktioniert.
