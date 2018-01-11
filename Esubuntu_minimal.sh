#!/bin/bash
#v0.4

# Ce script contient uniquement la partie "Esubuntu" (cf doc : https://github.com/dane-lyon/experimentation/blob/master/README.md)
# Cela concerne uniquement les personnes qui ont déjà intégré leur poste via le script integrdom et qui veulent ajouter Esubuntu
# Si vous n'avez pas encore utilisé le script d'intégration, ce script est inutile car la partie "esubuntu" est maintenant incluse dans le script IntegrDom (avec choix au lancement)

#téléchargement des paquets
wget http://nux87.online.fr/esu_ubuntu/esu_ubuntu.zip
unzip esu_ubuntu.zip
  
#création du dossier upkg
mkdir /usr/local/upkg_client/
chmod -R 777 /usr/local/upkg_client

#installation de cntlm zenity et conky
add-apt-repository -y ppa:vincent-c/conky #conky est backporté pour avoir une version récente quelque soit la distrib
apt-get update
apt-get install -y zenity conky #cntlm 

#on lance la copie des fichiers
cp -rf ./esu_ubuntu/lightdm/* /etc/lightdm/
chmod +x /etc/lightdm/*.sh
cp -rf ./esu_ubuntu/xdg_autostart/* /etc/xdg/autostart/
chmod +x /etc/xdg/autostart/message_scribe.desktop
chmod +x /etc/xdg/autostart/scribe_background.desktop
  
#on lance la gestion du groupe
#salle du pc
echo "Veuillez entrer le groupe ESU de vos postes clients linux : "
read salle
echo "$salle" > /etc/GM_ESU

#on lance le script prof_firefox
chmod -R +x ./esu_ubuntu
./esu_ubuntu/firefox/prof_firefox.sh
  
# Mise en place des wallpaper pour les élèves, profs, admin
wget http://nux87.online.fr/esu_ubuntu/wallpaper.zip
unzip wallpaper.zip
mv wallpaper /usr/share/

#on inscrit la tache upkg dans crontab
echo "*/20 * * * * root /etc/lightdm/groupe.sh" > /etc/crontab
  
#dans le cas ou il resterai encore une trace de cntlm dans xdg autostart :
rm -f /etc/xdg/autostart/cntlm*

# Modification de la valeur en dur a la fin du fichier background.sh pour corresponde au bon groupe ESU
sed -i -e "s/posteslinux/$salle/g" /etc/lightdm/background.sh

exit
