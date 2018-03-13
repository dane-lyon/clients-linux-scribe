#!/bin/bash
#v0.4

# Ce script contient uniquement la partie "Esubuntu" (cf doc : https://github.com/dane-lyon/experimentation/blob/master/README.md)
# Cela concerne uniquement les personnes qui ont déjà intégré leur poste via le script integrdom et qui veulent ajouter Esubuntu
# Si vous n'avez pas encore utilisé le script d'intégration, ce script est inutile car la partie "esubuntu" est maintenant incluse dans le script IntegrDom (avec choix au lancement)

# Affectation à la variable "version" suivant la variante utilisé
. /etc/lsb-release
if [ "$DISTRIB_RELEASE" = "14.04" ] || [ "$DISTRIB_RELEASE" = "17" ] || [ "$DISTRIB_RELEASE" = "17.3" ] ; then
  version=trusty # Ubuntu 14.04 ou Linux Mint 17/17.3
fi

if [ "$DISTRIB_RELEASE" = "16.04" ] || [ "$DISTRIB_RELEASE" = "18" ] || [ "$DISTRIB_RELEASE" = "18.3" ] || [ "$(echo "$DISTRIB_RELEASE" | cut -c -3)" = "0.4" ] ; then
  version=xenial # Ubuntu 16.04 ou Linux Mint 18/18.3 ou Elementary OS 0.4.x
fi

if [ "$DISTRIB_RELEASE" = "18.04" ] || [ "$DISTRIB_RELEASE" = "19" ] || [ "$DISTRIB_RELEASE" = "5.0" ] ; then 
  version=bionic # Ubuntu 18.04 
fi

#téléchargement des paquets
wget http://nux87.online.fr/esu_ubuntu/esu_ubuntu.zip
unzip esu_ubuntu.zip
  
#création du dossier upkg
mkdir /usr/local/upkg_client/
chmod -R 777 /usr/local/upkg_client

#installation de cntlm zenity et conky
if [ "$version" = "trusty" ] || [ "$version" = "xenial" ] ; then  #ajout du ppa uniquement pour trusty et xenial
    add-apt-repository -y ppa:vincent-c/conky #conky est backporté pour avoir une version récente quelque soit la distrib
    apt-get update
fi
apt-get install -y zenity conky

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
  
#mise en place des wallpaper pour les élèves, profs, admin
wget http://nux87.online.fr/esu_ubuntu/wallpaper.zip
unzip wallpaper.zip
mv wallpaper /usr/share/

#on inscrit la tache upkg dans crontab
echo "*/20 * * * * root /etc/lightdm/groupe.sh" > /etc/crontab
  
#dans le cas ou il resterait encore une trace de cntlm dans xdg autostart :
rm -f /etc/xdg/autostart/cntlm*

#modification de la valeur en dur à la fin du fichier background.sh pour correspondre au bon groupe ESU
sed -i -e "s/posteslinux/$salle/g" /etc/lightdm/background.sh

exit
