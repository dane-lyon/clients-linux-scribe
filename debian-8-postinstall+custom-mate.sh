#!/bin/bash
# script de Simon.B

# Script de post-install + légère customisation graphique pour la distribution "Debian 8 Jessie" avec l'environnement graphique "Mate".

# =====================================================================================================================
# IMPORTANT : ce script ne sert pas a l'intégration au domaine Scribe, il sert juste de postinstall et a la customisation.
# (c'est a dire installation de logiciel supplémentaire pour les établissements scolaires + quelques changements graphiques utiles)
# Pour intégrer une Debian, vous devez utiliser le script de "Jean François MAI" hebergé ici : 
# http://eole.ac-dijon.fr/pub/Contribs/Clients_Linux/
# =====================================================================================================================

# Le script doit être lancé avec les droits root obligatoirement !

if [ "$UID" -ne "0" ]
then
  echo "Il faut etre root pour executer ce script"
  exit 
fi 

# Récupération dépot
wget http://nux87.free.fr/debian/sources.list && mv -f sources.list /etc/apt/

# Base

# Si besoin d'activer multiarch (obligatoire pour : teamviewer ou skype par exemple) :
#dpkg --add-architecture i386

# Maj système
apt-get update 
apt-get -y --force-yes install pkg-mozilla-archive-keyring deb-multimedia-keyring
apt-get update
apt-get -y dist-upgrade

############################
# UI Mate Desktop
############################
apt-get -y install mate-desktop-environment-extra tango-icon-theme system-config-printer sudo


############################
# Internet / Navigation
############################
apt-get -y install iceweasel iceweasel-l10n-fr flashplugin-nonfree chromium chromium-l10n pepperflashplugin-nonfree 

############################
# Communication / Courrier 
############################
apt-get -y install icedove icedove-l10n-fr

############################
# Bureautique
############################

# Backportage libreoffice
apt-get -y -t jessie-backports install libreoffice libreoffice-l10n-fr libreoffice-gtk ttf-mscorefonts-installer 

############################
# Multimedia (lecture/encodage)
############################
apt-get -y install vlc

############################
# Création photo/vidéo/son/3d
############################
apt-get -y install pinta openshot audacity avidemux gimp gimp-help-fr gimp-data-extras blender inskape

############################
# Outils / Accessoires
############################
apt-get -y install vim unrar shutter

# Pour avoir VirtualBox 5 :
#echo "deb http://download.virtualbox.org/virtualbox/debian jessie contrib" >> /etc/apt/sources.list
#wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | apt-key add -
#apt-get update && apt-get -y install virtualbox-5.0

############################
# Système
############################
apt-get -y install gparted htop #glances

############################
# Programmation / Developpement
############################
apt-get -y install bluefish emacs scratch 

############################
# Server
############################
#apt-get -y install openssh-client openssh-server proftpd samba 

############################
# Sécurité / réseau
############################
#apt-get -y install aircrack-ng wireshark

############################
# Divers
############################
apt-get -y install celestia celestia-common-nonfree 

# Si besoin de Google Chrome (propriétaire) :
#wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && dpkg -i google-chrome-stable_current_amd64.deb ; apt-get -fy install

# TeamViewer V10 (+ activer multiarch !)
#wget http://downloadeu1.teamviewer.com/download/version_10x/teamviewer_10.0.46203_i386.deb && dpkg -i teamviewer_10.0.46203_i386.deb ; apt-get -fy install

# Skype (+ activer multiarch !)
# wget http://download.skype.com/linux/skype-debian_4.3.0.37-1_i386.deb && dpkg -i skype-debian_4.3.0.37-1_i386.deb ; apt-get -fy install

### Modification pour le gestionnaire de session Lightdm ###
cp /etc/lightdm/lightdm.conf /etc/lightdm/lightdm.conf_original
# pour afficher userlist (déconseillé pour étab)
#sed -i 's/^#greeter-hide-users=false/greeter-hide-users=false/' /etc/lightdm/lightdm.conf

### Changement fond d'écran LightDM
wget http://nux87.free.fr/debian/galaxie01.jpg && mv galaxie01.jpg /usr/share/images/desktop-base/galaxie01.jpg 
sed -i 's/login-background.svg/galaxie01.jpg/' /etc/lightdm/lightdm-gtk-greeter.conf

# Ajout de fond d'écran
wget http://nux87.free.fr/debian/galaxie02.jpg && mv galaxie02.jpg /usr/share/images/desktop-base/galaxie02.jpg

# Custom
wget http://nux87.free.fr/debian/skel.tar.gz 
tar xzvf skel.tar.gz -C /etc
chown -R root:root /etc/skel

# Pour activer pavé numérique au démarrage (désactivé par défaut, a tester)
apt-get -y install numlockx 
echo "greeter-setup-script=/usr/bin/numlockx on" | sudo tee -a /etc/lightdm/lightdm.conf 

# Installer driver Nvidia pour Debian (mode standard)
#apt-get -y install linux-headers-3.16 nvidia-kernel-dkms nvidia-glx mesa-utils
#mkdir /etc/X11/xorg.conf.d
#echo -e 'Section "Device"\n\tIdentifier "My GPU"\n\tDriver "nvidia"\nEndSection' > /etc/X11/xorg.conf.d/20-nvidia.conf
#pour tester performance (mesa-utils) : vblank_mode=0 glxgears

#Pour ne pas afficher logo nvidia au démarrage, dans le fichier xorg :
# Dans Section Device, ajouter :
#    Option         "NoLogo" "True"


# Amélioration graphique Grub & Démarrage 

apt-get -y install plymouth plymouth-themes 
sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="quiet"/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"/' /etc/default/grub 
#sed -i 's/#GRUB_GFXMODE=640x480/GRUB_GFXMODE=1920x1080/' /etc/default/grub
update-grub2

# Appliquer un thème spécifique de Plymouth
# Pour lister : plymouth-set-default-theme --list
#plymouth-set-default-theme -R tribar

#pour carte wifi
#apt-get -y install firmware-iwlwifi 

#firmware supplémentaire
apt-get -y install firmware-linux-nonfree

# Régler vsync (problème screen tearing)
# => soit ne pas activer compositeur de fenêtre soit installer compton comme compositeur alternatif
#apt-get -y install compton 
# ajouter dans les programme de démarrage : compton --backend glx --vsync opengl-swc


# Nettoyage pour terminer
apt-get -fy install 
apt-get -y autoremove --purge
apt-get -y clean
