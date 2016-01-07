#!/bin/bash

# AVERTISSEMENT
# Ce 2ème script post-install est optionnel et conçu pour la variante "Xubuntu" exclusivement, si vous utilisez une autre 
# variante, vous devez le modifier avant, en particulier la partie "customisation" qui est faite pour Xfce uniquement !

#############################################
# Run using sudo, of course.
#############################################
if [ "$UID" -ne "0" ]
then
  echo "Il faut etre root pour executer ce script. ==> sudo "
  exit 
fi 

# Vérification que le système est a jour
apt-get update && apt-get -y dist-upgrade

#-----------------------------------------
# Installation de logiciel supplémentaire 
#-----------------------------------------

#[[Paquet demandant confirmation utilisateur ]]
apt-get -y install ttf-mscorefonts-installer

#[[spécifique a XFCE ]] # a modifier si vous n'utilisez pas Xfce !
apt-get -y install xubuntu-restricted-extras xubuntu-restricted-addons xfce4-goodies xfwm4-themes
# si Lubuntu (LXDE), remplacer cette ligne par :
#apt-get -y install lubuntu-restricted-extras lubuntu-restricted-addons

#[[bureautique]]
apt-get -y install libreoffice libreoffice-l10n-fr libreoffice-help-fr freeplane scribus

#[[web]]
apt-get -y install firefox chromium-browser flashplugin-downloader pepperflashplugin-nonfree

#[[multimedia]]
apt-get -y install gimp pinta imagination openshot audacity inkscape gthumb vlc x264 ffmpeg2theora flac vorbis-tools lame mypaint libdvdread4

#[[systeme]]
apt-get -y install gparted vim pyrenamer unrar htop shutter

#[[mathematiques]]
apt-get -y install geogebra algobox carmetal

#[[sciences]]
apt-get -y install stellarium celestia avogadro

#[[programmation]]
apt-get -y install scratch idle-python2.7

#-----------------------------------------
# Customisation graphique Xubuntu (a modifier si vous n'utilisez pas XFCE !)
#-----------------------------------------

add-apt-repository -y ppa:docky-core/stable
apt-get update && apt-get -y install plank
wget http://nux87.online.fr/xubuntu-custom2/skel.tar.gz
tar xzvf skel.tar.gz -C /etc && rm -rf skel.tar.gz

#-----------------------------------------
# Fin
#-----------------------------------------

echo "L'installation est terminé, voulez vous rebooter ?"
read -p "Voulez-vous redémarrer immédiatement ? [O/n] " rep_reboot
if [ "$rep_reboot" = "O" ] || [ "$rep_reboot" = "o" ] || [ "$rep_reboot" = "" ] ; then
  reboot
fi
