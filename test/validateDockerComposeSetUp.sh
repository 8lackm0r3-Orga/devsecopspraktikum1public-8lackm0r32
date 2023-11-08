echo -e "\n----- Creating Container -----\n"
docker-compose up -d
echo -e "\n----- Waiting for Container to run -----\n"
sleep 3
echo -e "\n----- Finished Waiting -----\n"

FEHLER=0

echo -e "\n----- Check Dienst -----\n"
DIENST=$(docker inspect threatdragon | jq -r '.[].Config.Hostname')
if [ "$DIENST" = "threatdragon" ]
then
echo "Dienstname korrekt!"
else
echo "Dienstname falsch!"
FEHLER=$((FEHLER+1))
fi

echo -e "\n----- Check Used Image -----\n"
IMAGE=$(docker inspect threatdragon | jq -r '.[].Config.Image')
if [ "$IMAGE" = "owasp/threat-dragon:v2.0.8" ]
then
echo "Korrektes Image!"
else
echo "Falsches Image!"
FEHLER=$((FEHLER+1))
fi

echo -e "\n----- Check Connection -----\n"
if [ "$(curl -sL -w '%{http_code}' localhost:8080 -o /dev/null)" = "200" ]
then
echo "Verbindung hergestellt!"
else
echo "Es konnte keine Verbindung hergestellt werden. Überprüfen Sie die Ports"
FEHLER=$((FEHLER+1))
fi

echo -e "\n----- Result: -----\n"
if [ $FEHLER -gt 0 ]
then 
echo "Schauen Sie nochmal in ihre Docker-Compose und config Datei rein"
exit 1
else
echo "Sieht soweit in Ordnung aus"
fi
