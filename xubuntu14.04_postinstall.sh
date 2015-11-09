#!/bin/bash

#-----------------------------------------
# Installation de logiciel supplémentaire 
#-----------------------------------------

#[[xubuntu-restrictive]]
apt-get -y install xubuntu-restricted-extras xubuntu-restricted-addons 

#[[multimedia]]
apt-get -y install pinta imagination openshot audacity inkscape gthumb vlc x264 ffmpeg2theora oggvideotools mplayer hugin gimp ogmrip flac vorbis-tools lame mypaint libdvdread4

#[[systeme]]
apt-get -y install gparted vim pyrenamer rar xfce4-goodies xfwm4-themes

#[[web]]
apt-get -y install chromium-browser flashplugin-downloader ttf-mscorefonts-installer

#[[mathematiques]]
apt-get -y install geogebra algobox carmetal

#[[sciences]]
apt-get -y install stellarium celestia avogadro marble

#[[bureautique]]
apt-get -y install libreoffice libreoffice-l10n-fr libreoffice-help-fr freeplane shutter scribus

#[[programmation]]
apt-get -y install scratch idle-python2.7

#-----------------------------------------
# Customisation Xubuntu 
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
