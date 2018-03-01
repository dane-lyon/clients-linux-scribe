#!/bin/bash
# version 2.0.0

# Ce script sert à installer des logiciels supplémentaires utiles pour les collèges & lyçées
# Ce script est utilisable pour Ubuntu et variantes en 14.04, 16.04 et 18.04

#############################################
# Run using sudo, of course.
#############################################
if [ "$UID" -ne "0" ] ; then
  echo "Il faut etre root pour executer ce script. ==> sudo "
  exit 
fi 

# Pour identifier le numéro de la version
. /etc/lsb-release

# Affectation à la variable "version" suivant la variante utilisée

if [ "$DISTRIB_RELEASE" = "14.04" ] ; then
  version=trusty
fi

if [ "$DISTRIB_RELEASE" = "16.04" ] || [ "$DISTRIB_RELEASE" = "18.3" ] || [ "$(echo "$DISTRIB_RELEASE" | cut -c -3)" = "0.4" ] ; then
  version=xenial
fi

if [ "$DISTRIB_RELEASE" = "18.04" ] ; then
  version=bionic
fi

########################################################################
#vérification de la bonne version d'Ubuntu
########################################################################

if [ "$version" != "trusty" ] && [ "$version" != "xenial" ] && [ "$version" != "bionic" ] ; then
  echo "Vous n'êtes pas sur une version compatible ! Le script est conçu uniquement pour les LTS (non-obsolètes), c'est à dire la 14.04 ou la 16.04 ou la 18.04"
  exit
fi

# désactiver mode intéractif pour automatiser l'installation de wireshark
export DEBIAN_FRONTEND="noninteractive"

# Ajout dépot partenaire
add-apt-repository "deb http://archive.canonical.com/ubuntu $(lsb_release -sc) partner" 

# Vérification que le système est à jour
apt-get update ; apt-get -y dist-upgrade

#########################################
# Paquets uniquement pour Trusty (14.04)
#########################################
if [ "$version" = "trusty" ] ; then

  # paquet
  apt-get -y install idle-python3.4 gstreamer0.10-plugins-ugly celestia

  # Backportage LibreOffice
  add-apt-repository -y ppa:libreoffice/ppa ; apt-get update ; apt-get -y upgrade

  # Pour Google Earth : 
  apt-get -y install libfontconfig1:i386 libx11-6:i386 libxrender1:i386 libxext6:i386 libgl1-mesa-glx:i386 libglu1-mesa:i386 libglib2.0-0:i386 libsm6:i386
  wget https://dl.google.com/dl/earth/client/current/google-earth-stable_current_i386.deb ; dpkg -i google-earth-stable_current_i386.deb ; apt-get -fy install ; rm -f google-earth-stable_current_i386.deb 
fi

#########################################
# Paquets uniquement pour Xenial (16.04)
#########################################
if [ "$version" = "xenial" ] ; then

  # Installation style "Breeze" pour LibreOffice si il est n'est pas installé (exemple : Xubuntu 16.04...)
  apt install -y libreoffice-style-breeze ;
  # paquet
  apt install -y idle-python3.5 x265 ;

  # Pour Google Earth (64 bits only) sur Xenial #a décommenter pour avoir google earth sur une 16.04 !
  wget --no-check-certificate https://dl.google.com/dl/earth/client/current/google-earth-stable_current_amd64.deb 
  wget http://ftp.fr.debian.org/debian/pool/main/l/lsb/lsb-core_4.1+Debian13+nmu1_amd64.deb
  wget http://ftp.fr.debian.org/debian/pool/main/l/lsb/lsb-security_4.1+Debian13+nmu1_amd64.deb 
  dpkg -i lsb*.deb
  dpkg -i google-earth*.deb
  apt-get -fy install 
  
  # Pour Celestia X64 # A décommenter si vous voulez Celestia pour la 16.04
  wget --no-check-certificate https://raw.githubusercontent.com/sibe39/scripts_divers/master/Celestia_On_Xenial.sh
  chmod +x Celestia_On_Xenial.sh ; ./Celestia_On_Xenial.sh ; rm -f Celestia_On_Xenial.sh
fi

#########################################
# Paquet uniquement pour Bionic (18.04)
#########################################
if [ "$version" = "bionic" ] ; then

  # paquet
  apt install -y idle-python3.6 x265

  # Backportage LibreOffice
  add-apt-repository -y ppa:libreoffice/ppa ; apt-get update ; apt-get -y upgrade

  # Google Earth Pro 
  wget https://dl.google.com/dl/earth/client/current/google-earth-pro-stable_current_amd64.deb
  dpkg -i google-earth-pro-stable_current_amd64.deb
  apt install -fy ; rm google-earth-pro-stable_current_amd64.deb
  
  # Celestia
  wget --no-check-certificate https://raw.githubusercontent.com/BionicBeaver/Divers/master/CelestiaBionic.sh
  chmod +x CelestiaBionic.sh ; ./CelestiaBionic.sh ; rm CelestiaBionic.sh
  
  # Pilote imprimante openprinting
  apt install -y openprinting-ppds
fi



#=======================================================================================================#

# Installation quelque soit la variante et la version 

if [ "$version" != "bionic" ] ; then
  # drivers imprimantes (sauf pour Bionic ou il est installé différemment)
  wget http://www.openprinting.org/download/printdriver/debian/dists/lsb3.2/contrib/binary-amd64/openprinting-gutenprint_5.2.7-1lsb3.2_amd64.deb
  dpkg -i openprinting-gutenprint_5.2.7-1lsb3.2_amd64.deb ; apt-get -fy install ; rm openprinting-gutenprint*
  
  # Gdevelop (PPA pas encore actif pour la 18.04)
  add-apt-repository -y ppa:florian-rival/gdevelop
  apt-get update ; apt-get -y install gdevelop
fi

# drivers pour les scanners les plus courants

apt-get -y install sane

# Police d'écriture de Microsoft
echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | /usr/bin/debconf-set-selections | apt-get -y install ttf-mscorefonts-installer ;

# Oracle Java 8
add-apt-repository -y ppa:webupd8team/java ; apt-get update ; echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections | apt-get -y install oracle-java8-installer

#[ Bureautique ]
apt-get -y install libreoffice libreoffice-gtk libreoffice-l10n-fr freeplane scribus gnote xournal cups-pdf

#[ Web ]
apt-get -y install chromium-browser chromium-browser-l10n ;
apt-get -y install adobe-flashplugin ; #permet d'avoir flash en même temps pour firefox et chromium

#[ Video / Audio ]
apt-get -y install imagination openshot audacity vlc x264 ffmpeg2theora flac vorbis-tools lame oggvideotools mplayer ogmrip goobox
#x265 installé sur la 16.04 en +

#[ Graphisme / Photo ]
apt-get -y install blender sweethome3d gimp pinta inkscape gthumb mypaint hugin shutter

#[ Système ]
apt-get -y install gparted vim pyrenamer rar unrar htop diodon p7zip-full gdebi

# Wireshark
debconf-set-selections <<< "wireshark-common/install-setuid true"
apt-get -y install wireshark 
sed -i -e "s/,dialout/,dialout,wireshark/g" /etc/security/group.conf

#[ Mathématiques ]
apt-get -y install geogebra algobox carmetal scilab

#[ Sciences ]
apt-get -y install stellarium avogadro 
#celestia installé uniquement sur la 14.04, cf en haut

#[ Programmation ]
apt-get -y install scratch ghex geany imagemagick gcolor2
apt-get -y install python3-pil.imagetk python3-pil traceroute python3-tk #python3-sympy

#[ Serveur ]
#apt-get -y install openssh-server #à décommenter si vous utilisez "Ansible"
#=======================================================================================================#

################################
# Concerne Ubuntu / Gnome
################################
if [ "$(which gnome-shell)" = "/usr/bin/gnome-shell" ] ; then  # si GS install
  #[ Paquet AddOns ]
  apt install -y ubuntu-restricted-extras ubuntu-restricted-addons gnome-tweak-tool
  apt install -y nautilus-image-converter nautilus-script-audio-convert
fi

################################
# Concerne Ubuntu / Unity
################################
if [ "$(which unity)" = "/usr/bin/unity" ] ; then  # si Ubuntu/Unity alors :
  #[ Paquet AddOns ]
  apt-get -y install ubuntu-restricted-extras ubuntu-restricted-addons unity-tweak-tool
  apt-get -y install nautilus-image-converter nautilus-script-audio-convert
fi

################################
# Concerne Xubuntu / XFCE
################################
if [ "$(which xfwm4)" = "/usr/bin/xfwm4" ] ; then # si Xubuntu/Xfce alors :
  #[ Paquet AddOns ]
  apt-get -y install xubuntu-restricted-extras xubuntu-restricted-addons xfce4-goodies xfwm4-themes

  # Customisation XFCE
  add-apt-repository -y ppa:docky-core/stable ; apt-get update ; apt-get -y install plank ;
  wget --no-check-certificate https://dane.ac-lyon.fr/spip/IMG/tar/skel_xub1404.tar ; tar xvf skel_xub1404.tar -C /etc ; rm -rf skel_xub1404.tar
fi

################################
# Concerne Ubuntu Mate 16.04
################################
if [ "$(which caja)" = "/usr/bin/caja" ] && [ "$DISTRIB_RELEASE" = "16.04" ] ; then # si Ubuntu Mate 16.04 alors :
  #paquet
  apt-get -y install ubuntu-restricted-extras mate-desktop-environment-extras
fi

################################
# Concerne Lubuntu / LXDE
################################
if [ "$(which pcmanfm)" = "/usr/bin/pcmanfm" ] ; then  # si Lubuntu / Lxde alors :
  #[ Paquet AddOns ]
  apt-get -y install lubuntu-restricted-extras lubuntu-restricted-addons
fi

########################################################################
#nettoyage station 
########################################################################
apt-get -fy install ; apt-get -y autoremove --purge ; apt-get -y clean ;

########################################################################
#FIN
########################################################################
echo "Le script de postinstall a terminé son travail"
read -p "Voulez-vous redémarrer immédiatement ? [O/n] " rep_reboot
if [ "$rep_reboot" = "O" ] || [ "$rep_reboot" = "o" ] || [ "$rep_reboot" = "" ] ; then
  reboot
fi
