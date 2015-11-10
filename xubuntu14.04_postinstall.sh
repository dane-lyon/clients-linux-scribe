#!/bin/bash

#############################################
# Run using sudo, of course.
#############################################
if [ "$UID" -ne "0" ]
then
  echo "Il faut etre root pour executer ce script. ==> sudo "
  exit 
fi 

#-----------------------------------------
# Installation de logiciel supplémentaire 
#-----------------------------------------

#[[spécifique a XFCE ]]
apt-get -y install xubuntu-restricted-extras xubuntu-restricted-addons xfce4-goodies xfwm4-themes
# si Lubuntu (LXDE), remplacer cette ligne par :
#apt-get -y install lubuntu-restricted-extras lubuntu-restricted-addons

#[[multimedia]]
apt-get -y install gimp pinta imagination openshot audacity inkscape gthumb vlc x264 ffmpeg2theora flac vorbis-tools lame mypaint libdvdread4

#[[systeme]]
apt-get -y install gparted vim pyrenamer unrar htop shutter

#[[web]]
apt-get -y install firefox chromium-browser flashplugin-downloader pepperflashplugin-nonfree 

#[[mathematiques]]
apt-get -y install geogebra algobox carmetal

#[[sciences]]
apt-get -y install stellarium celestia avogadro

#[[bureautique]]
apt-get -y install libreoffice libreoffice-l10n-fr libreoffice-help-fr ttf-mscorefonts-installer freeplane scribus

#[[programmation]]
apt-get -y install scratch idle-python2.7


#-----------------------------------------
# Customisation graphique Xubuntu 
#-----------------------------------------

# A venir...


#-----------------------------------------
# Fin
#-----------------------------------------

echo "L'installation est terminé, voulez vous rebooter ?"
read -p "Voulez-vous redémarrer immédiatement ? [O/n] " rep_reboot
if [ "$rep_reboot" = "O" ] || [ "$rep_reboot" = "o" ] || [ "$rep_reboot" = "" ] ; then
  reboot
fi
