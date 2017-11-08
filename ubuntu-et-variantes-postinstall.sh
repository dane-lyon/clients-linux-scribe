#!/bin/bash
# version 1.0.7

# Variantes concernées :
# - Ubuntu 14.04/16.04
# - Xubuntu 14.04/16.04
# - Lubuntu 14.04/16.04
# - Ubuntu Mate 16.04
# - Linux Mint 17.X/18.X

#############################################
# Run using sudo, of course.
#############################################
if [ "$UID" -ne "0" ] ; then
  echo "Il faut etre root pour executer ce script. ==> sudo "
  exit 
fi 

# Pour identifier le numéro de la version (14.04, 16.04...)
. /etc/lsb-release

# Affectation a la variable "version" suivant la variante utilisé
if [ "$DISTRIB_RELEASE" = "14.04" ] || [ "$DISTRIB_RELEASE" = "17" ] || [ "$DISTRIB_RELEASE" = "17.1" ] || [ "$DISTRIB_RELEASE" = "17.2" ] || [ "$DISTRIB_RELEASE" = "17.3" ] || [ "$DISTRIB_RELEASE" = "0.3" ] ; then
  version=trusty
fi

if [ "$DISTRIB_RELEASE" = "16.04" ] || [ "$DISTRIB_RELEASE" = "18" ] || [ "$DISTRIB_RELEASE" = "18.1" ] || [ "$DISTRIB_RELEASE" = "18.2" ] || [ "$DISTRIB_RELEASE" = "0.4" ] ; then
  version=xenial
fi

########################################################################
#vérification de la bonne version d'Ubuntu
########################################################################

if [ "$version" != "trusty" ] && [ "$version" != "xenial" ] ; then
  echo "Vous n'êtes pas sûr une version compatible ! Le script est conçu uniquement pour les LTS (non-obsolètes), c'est a dire la 14.04 ou la 16.04"
  exit
fi

# Vérification que le système est a jour
apt-get update ; apt-get -y dist-upgrade

#########################################
# Paquet uniquement pour Trusty
#########################################
if [ "$version" = "trusty" ] ; then
  # activation dépot partenaire 
  if [ "$(which mdm)" != "/usr/sbin/mdm"  ] ; then # activation du dépot partenaire (sauf pour Mint car déjà présent)
    echo "deb http://archive.canonical.com/ubuntu trusty partner" >> /etc/apt/sources.list
  fi

  # paquet
  apt-get -y install idle-python3.4 gstreamer0.10-plugins-ugly celestia

  # Backportage LibreOffice
  add-apt-repository -y ppa:libreoffice/ppa ; apt-get update ; apt-get -y upgrade

  # Pour Google Earth : 
  apt-get -y install libfontconfig1:i386 libx11-6:i386 libxrender1:i386 libxext6:i386 libgl1-mesa-glx:i386 libglu1-mesa:i386 libglib2.0-0:i386 libsm6:i386
  wget https://dl.google.com/dl/earth/client/current/google-earth-stable_current_i386.deb ; dpkg -i google-earth-stable_current_i386.deb ; apt-get -fy install ; rm -f google-earth-stable_current_i386.deb 
fi

#########################################
# Paquet uniquement pour Xenial
#########################################
if [ "$version" = "xenial" ] ; then

  # activation dépot partenaire 
  if [ "$(which mdm)" != "/usr/sbin/mdm"  ] ; then # activation du dépot partenaire (sauf pour Mint car déjà présent)
    echo "deb http://archive.canonical.com/ubuntu xenial partner" >> /etc/apt/sources.list
    apt-get update #pour prendre en compte le dépot 
  fi
  
  # Installation style "Breeze" pour LibreOffice si il est n'est pas installé (exemple : Xubuntu 16.04...)
  apt install -y libreoffice-style-breeze ;
  # paquet
  apt install -y idle-python3.5 x265 ;

  # Pour Google Earth (64 bits only) sur Xenial # A décommenter si vous voulez Google Earth
  #wget --no-check-certificate https://dl.google.com/dl/earth/client/current/google-earth-stable_current_amd64.deb 
  #wget http://ftp.fr.debian.org/debian/pool/main/l/lsb/lsb-core_4.1+Debian13+nmu1_amd64.deb
  #wget http://ftp.fr.debian.org/debian/pool/main/l/lsb/lsb-security_4.1+Debian13+nmu1_amd64.deb 
  #dpkg -i lsb*.deb
  #dpkg -i google-earth*.deb
  #apt-get -fy install 
  
  # Pour Celestia X64 # A décommenter si vous voulez Celestia
  #wget --no-check-certificate https://raw.githubusercontent.com/sibe39/scripts_divers/master/Celestia_On_Xenial.sh
  #chmod +x Celestia_On_Xenial.sh
  #./Celestia_On_Xenial.sh
  #rm -f Celestia_On_Xenial.sh

fi

#=======================================================================================================#

# Installation quelque soit la variante et la version 

# drivers imprimantes
wget http://www.openprinting.org/download/printdriver/debian/dists/lsb3.2/contrib/binary-amd64/openprinting-gutenprint_5.2.7-1lsb3.2_amd64.deb
dpkg -i openprinting-gutenprint_5.2.7-1lsb3.2_amd64.deb ;
apt-get -fy install ;

# driver spour les scanners les plus courants

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

#[ Systeme ]
apt-get -y install gparted vim pyrenamer rar unrar htop diodon p7zip-full gdebi

#[ Mathematiques ]
apt-get -y install geogebra algobox carmetal scilab

#[ Sciences ]
apt-get -y install stellarium avogadro 
#celestia installé uniquement sur la 14.04, cf en haut

#[ Programmation ]
apt-get -y install scratch ghex geany imagemagick
apt-get -y python3-pip
pip3 install lxml sympy

#[ Serveur ]
#apt-get -y install openssh-server #a décommenter si vous utilisez "Ansible"
#=======================================================================================================#


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
