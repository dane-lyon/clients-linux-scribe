#!/bin/bash
# version 2.0.3

# Ce script sert à installer des logiciels supplémentaires utiles pour les collèges & lyçées
# Ce script est utilisable pour Ubuntu et variantes en 14.04, 16.04 et 18.04

# Bonus : pour installer Google Earth + la lecture de dvd à la fin, utiliser le paramètre "--extra" => sudo ./script.sh --extra

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

if [ "$DISTRIB_RELEASE" = "14.04" ] || [ "$DISTRIB_RELEASE" = "17.3" ] ; then
  version=trusty # Ubuntu 14.04 / Mint 17.3
fi

if [ "$DISTRIB_RELEASE" = "16.04" ] || [ "$DISTRIB_RELEASE" = "18.3" ] || [ "$(echo "$DISTRIB_RELEASE" | cut -c -3)" = "0.4" ] ; then
  version=xenial # Ubuntu 16.04 / Mint 18.3 / Elementary OS 0.4
fi

if [ "$DISTRIB_RELEASE" = "18.04" ] || [ "$DISTRIB_RELEASE" = "19" ] || [ "$DISTRIB_RELEASE" = "5.0" ] ; then
  version=bionic # Ubuntu 18.04 / Mint 19 / Elementary OS 5.0
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

  # Backportage LibreOffice (sinon version trop ancienne sur la 14.04)
  add-apt-repository -y ppa:libreoffice/ppa ; apt-get update ; apt-get -y upgrade
  
  if [ "$1" = "--extra" ] ; then 
    # Google Earth
    apt-get -y install libfontconfig1:i386 libx11-6:i386 libxrender1:i386 libxext6:i386 libgl1-mesa-glx:i386 libglu1-mesa:i386 libglib2.0-0:i386 libsm6:i386
    wget https://dl.google.com/dl/earth/client/current/google-earth-stable_current_i386.deb ; 
    dpkg -i google-earth-stable_current_i386.deb ; apt-get -fy install ; rm -f google-earth-stable_current_i386.deb 
  fi  
  
fi

#########################################
# Paquets uniquement pour Xenial (16.04)
#########################################
if [ "$version" = "xenial" ] ; then

  # Installation style "Breeze" pour LibreOffice si il est n'est pas installé (exemple : Xubuntu 16.04...)
  apt install -y libreoffice-style-breeze ;
  # paquet
  apt install -y idle-python3.5 x265 ;
  
  # Backportage LibreOffice (si besoin de backporter LO, décommenter !)
  add-apt-repository -y ppa:libreoffice/ppa ; apt update ; apt upgrade -y

  if [ "$1" = "--extra" ] ; then 
    # Google Earth
    wget --no-check-certificate https://dl.google.com/dl/earth/client/current/google-earth-stable_current_amd64.deb 
    wget http://ftp.fr.debian.org/debian/pool/main/l/lsb/lsb-core_4.1+Debian13+nmu1_amd64.deb
    wget http://ftp.fr.debian.org/debian/pool/main/l/lsb/lsb-security_4.1+Debian13+nmu1_amd64.deb 
    dpkg -i lsb*.deb ; dpkg -i google-earth*.deb ; apt install -fy ; rm -f lsb*.deb && rm -f google-earth*.deb
  fi
  
  # Celestia
  wget --no-check-certificate https://raw.githubusercontent.com/simbd/Scripts_Ubuntu/master/Celestia_pour_Xenial.sh
  chmod +x Celestia* ; ./Celestia_pour_Xenial.sh ; rm -f Celestia*
fi

#########################################
# Paquet uniquement pour Bionic (18.04)
#########################################
if [ "$version" = "bionic" ] ; then

  # paquet
  apt install -y idle-python3.6 x265

  if [ "$1" = "--extra" ] ; then 
    # Backportage LibreOffice 
    add-apt-repository -y ppa:libreoffice/ppa ; apt update ; apt upgrade -y

    # Google Earth Pro x64 
    wget https://dl.google.com/dl/earth/client/current/google-earth-pro-stable_current_amd64.deb
    dpkg -i google-earth-pro-stable_current_amd64.deb ; apt install -fy
    sed -i -e "s/deb http/deb [arch=amd64] http/g" /etc/apt/sources.list.d/google-earth* #permet d'ignorer le 32bits sinon erreur lors d'un apt update
    rm google-earth-pro*
  fi
  
  # Celestia
  wget --no-check-certificate https://raw.githubusercontent.com/simbd/Scripts_Ubuntu/master/Celestia_pour_Bionic.sh
  chmod +x Celestia_pour_Bionic.sh ; ./Celestia_pour_Bionic.sh ; rm Celestia*
  
  # Pilote imprimante openprinting
  apt install -y openprinting-ppds
fi

#=======================================================================================================#

# Installation quelque soit la variante et la version 

if [ "$version" != "bionic" ] ; then  # Installation spécifique pour 14.04 ou 16.04
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

#[ Programmation ]
apt-get -y install scratch ghex geany imagemagick gcolor2
apt-get -y install python3-pil.imagetk python3-pil traceroute python3-tk #python3-sympy

#[ Serveur ]
#apt-get -y install openssh-server #à décommenter si vous utilisez "Ansible"

#=======================================================================================================#
# Installation spécifique suivant l'environnement de bureau

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
  if [ "$version" = "trusty" ] || [ "$version" = "xenial" ] ; then #ajout ppa pour 14.04 et 16.04 (pas nécessaire pour la 18.04)
    add-apt-repository -y ppa:docky-core/stable ; apt-get update   
  fi
  apt-get -y install plank ; wget --no-check-certificate https://dane.ac-lyon.fr/spip/IMG/tar/skel_xub1404.tar
  tar xvf skel_xub1404.tar -C /etc ; rm -rf skel_xub1404.tar
fi

################################
# Concerne Ubuntu Mate
################################
if [ "$(which caja)" = "/usr/bin/caja" ] ; then # si Ubuntu Mate 
  apt-get -y install ubuntu-restricted-extras mate-desktop-environment-extras
  apt-get -y purge ubuntu-mate-welcome
fi

################################
# Concerne Lubuntu / LXDE
################################
if [ "$(which pcmanfm)" = "/usr/bin/pcmanfm" ] ; then  # si Lubuntu / Lxde alors :
  apt-get -y install lubuntu-restricted-extras lubuntu-restricted-addons
fi

# Lecture DVD (intervention demandé)
if [ "$1" = "--extra" ] ; then 

  if [ "$version" = "trusty" ] ; then #lecture dvd pour 14.04
    apt-get install libdvdread4 -y
    bash /usr/share/doc/libdvdread4/install-css.sh
  fi
  
  if [ "$version" = "xenial" ] || [ "$version" = "bionic" ] ; then #lecture dvd pour 16.04 ou 18.04
    apt install -y libdvd-pkg
    dpkg-reconfigure libdvd-pkg
  fi
  
fi


########################################################################
#nettoyage station 
########################################################################
apt-get update ; apt-get -fy install ; apt-get -y autoremove --purge ; apt-get -y clean ;
clear

########################################################################
#FIN
########################################################################
echo "Le script de postinstall a terminé son travail"
read -p "Voulez-vous redémarrer immédiatement ? [O/n] " rep_reboot
if [ "$rep_reboot" = "O" ] || [ "$rep_reboot" = "o" ] || [ "$rep_reboot" = "" ] ; then
  reboot
fi
