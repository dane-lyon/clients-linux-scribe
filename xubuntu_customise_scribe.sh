#!/bin/bash

#######################################################################################
# XUBUNTU 14.04 LTS CUSTOMISE (par Simon BERNARD) dans environnement Scribe 2.3 ou 2.4
#######################################################################################

# Aperçu du bureau ici : http://nsa37.casimages.com/img/2015/06/05/150605114538855711.png

#Ce script a pour but d'obtenir un Xubuntu pleinement fonctionnel et customisé
#pour être jolie de base, nouveauté par rapport au script non customisé :

#- dock (Plank) en bas du bureau avec les raccourcis des principales applications (firefox, chromium, libreoffice...) pour plus de confort
#- raccourcis du dossier perso et des partages directement sur le bureau
#- changement du wallpaper par défaut
#- marque-page des moteurs de recherche google + ixquick intégré dans Firefox + barre des raccourci activé
#- thème graphique modifié et transparence activé sur le menu en haut
#- la toute dernière version de LibreOffice intégré (via PPA) (4.4.2.X actuellement) + bonus libreoffice : modèle présentation supplémentaire etc...
#- les logiciels utiles pour un établissement scolaire déjà intégré (pas besoin de passer le script post install après)
#- les logiciels inutile de xubuntu pour un établissement scolaire (comme jeu de mines, sudoku, xchat) désinstallé
#- les addons/extra (xubuntu-restricted-extra) installé (flash, java, codec...)

######### Intégration client scribe 2.3 et 2.4 pour Xubuntu14.04 LTS - script CUSTOM #########

# Ce script est compatible avec un Scribe 2.3 et 2.4 par contre si vous avez un scribe 2.4, afin d'avoir
# tous les partages (communs, matière etc...) il faut faire cette petite manip sur votre scribe :
# https://raw.githubusercontent.com/sibe39/divers/master/scribe24_avoir_les_partages

###########################################################################
## Changement apporté (simon) pour la version 14.04 par rapport a la 12.04 :

# - valeur de vérification 12.04 remplacé par 14.04
# - paquet smbfs remplacé par cifs-utils

## Autres changements spécifiques à la version XFCE :

# - La ligne "greeter-session=unity-greeter" est retiré car sinon elle empèche le démarrage de Xubuntu
# - La partie spécifique a Unity est supprimé (suppression applet / paramétrage laucher unity).

###########################################################################

#Christophe Deze - Rectorat de Nantes
#Cédric Frayssinet - Mission Tice Ac-lyon
#Xavier GAREL - Mission Tice Ac-lyon
#Simon BERNARD - Dane Reseau - Lyon
#############################################

#############################################
# version 0.1 (avec proxy system)

###########################################################################
#Paramétrage par défaut
#Changez les valeurs, ainsi, il suffira de taper 'entrée' à chaque question
###########################################################################
scribe_def_ip="172.16.0.241"
proxy_def_ip="172.16.0.252"
proxy_def_port="3128"
proxy_gnome_noproxy="[ 'localhost', '127.0.0.0/8', '172.16.0.0/16', '192.168.0.0/16', '*.crdp-lyon.fr', '*.crdplyon.lan' ]"
proxy_env_noproxy="localhost,127.0.0.1,192.168.0.0/16,172.16.0.0/16,.crdp-lyon.fr,.crdplyon.lan"
pagedemarragepardefaut="http://www2.ac-lyon.fr/serv_ress/mission_tice/wiki/"

#############################################
# Run using sudo, of course.
#############################################
if [ "$UID" -ne "0" ]
then
  echo "Il faut etre root pour executer ce script. ==> sudo "
  exit 
fi 

########################################################################
#vérification de la bonne version d'Ubuntu
########################################################################
. /etc/lsb-release
if [ "$DISTRIB_RELEASE" != "14.04" ]
then
  echo "ce n'est pas Xubuntu en version 14.04 !"
  exit
fi

##############################################################################
### Questionnaire : IP du scribe, proxy firefox, port proxy, exception proxy #
##############################################################################
read -p "Donnez l'ip du serveur Scribe ? [$scribe_def_ip] " ip_scribe
if [ "$ip_scribe" = "" ] ; then
 ip_scribe=$scribe_def_ip
fi
echo "Adresse du serveur Scribe = $ip_scribe"

#####################################
# Existe-t-il un proxy à paramétrer ?
#####################################

read -p "Faut-il enregistrer l'utilisation d'un proxy ? [O/n] " rep_proxy
if [ "$rep_proxy" = "O" ] || [ "$rep_proxy" = "o" ] || [ "$rep_proxy" = "" ] ; then
  read -p "Donnez l'adresse ip du proxy ? [$proxy_def_ip] " ip_proxy
  if [ "$ip_proxy" = "" ] ; then
    ip_proxy=$proxy_def_ip
  fi
  read -p "Donnez le n° port du proxy ? [$proxy_def_port] " port_proxy
  if [ "$port_proxy" = "" ] ; then
    port_proxy=$proxy_def_port
  fi
else
  ip_proxy=""
  port_proxy=""
fi

########################################################################
#rendre debconf silencieux
########################################################################
export DEBIAN_FRONTEND="noninteractive"
export DEBIAN_PRIORITY="critical"

########################################################################
#Mettre la station à l'heure à partir du serveur Scribe
########################################################################
ntpdate $ip_scribe

########################################################################
#installation des paquets necessaires
#numlockx pour le verrouillage du pave numerique
#unattended-upgrades pour forcer les mises à jour de sécurité à se faire
########################################################################

## Mise a jour du système
apt-get update && apt-get -y dist-upgrade

## Installation paquet ldap pour rejoindre le domaine 
apt-get install -y ldap-auth-client libpam-mount cifs-utils nscd numlockx unattended-upgrades

######################################################################################
#Désinstallation de paquet pré-installé de Xubuntu mais inutile dans le cadre scolaire
######################################################################################
apt-get -y remove abiword gnumeric gnome-sudoku gnome-mines xchat gmusicbrowser parole transmission-gtk 

########################################################################
# Installation de paquet 
########################################################################

# Dernière version de LibreOffice
add-apt-repository -y ppa:libreoffice/ppa
apt-get update
apt-get -y install libreoffice libreoffice-l10n-fr libreoffice-help-fr hyphen-fr
apt-get -y install libreoffice-ogltrans libreoffice-templates openclipart-libreoffice

# Dock (Plank)
add-apt-repository -y ppa:ricotz/docky
apt-get update
apt-get -y install plank

# Autres logiciels utiles dans un établissement scolaire 

# [[ MULTIMEDIA ]]
apt-get -y install pinta imagination openshot audacity inkscape gthumb vlc x264 ffmpeg2theora oggvideotools hugin gimp ogmrip flac vorbis-tools lame mypaint libdvdread4

# [[ SYSTEME ]]
apt-get -y install htop gparted vim pyrenamer rar unrar

# [[ WEB ]]
apt-get -y install chromium-browser chromium-browser-l10n flashplugin-installer pepperflashplugin-nonfree

# [[ BUREAUTIQUE ]]
apt-get -y install ttf-mscorefonts-installer freeplane shutter scribus

# [[ MATH ]]
apt-get -y install geogebra algobox carmetal

# [[ SCIENCES ]]
apt-get -y install stellarium celestia avogadro

# Google Earth
apt-get -y install libfontconfig1:i386 libx11-6:i386 libxrender1:i386 libxext6:i386 libgl1-mesa-glx:i386 libglu1-mesa:i386 libglib2.0-0:i386 libsm6:i386 ;
wget http://dl.google.com/dl/earth/client/current/google-earth-stable_current_i386.deb && dpkg -i google-earth-stable_current_i386.deb ;
apt-get -fy install ;

# [[ PROGRAMMATION ]]
apt-get -y install scratch vim anjuta bluefish

########################################################################
# Optimisation / Finalisation Xubuntu
########################################################################

apt-get -y install xfce4-goodies xfwm4-themes
apt-get -y install xubuntu-restricted-addons xubuntu-restricted-extras
apt-get -y install xscreensaver-data-extra xscreensaver-gl-extra

########################################################################
# activation auto des mises à jour de sécu
########################################################################
echo "APT::Periodic::Update-Package-Lists \"1\";
APT::Periodic::Unattended-Upgrade \"1\";" > /etc/apt/apt.conf.d/20auto-upgrades

########################################################################
# Configuration du fichier pour le LDAP /etc/ldap.conf
########################################################################
echo "
# /etc/ldap.conf
host $ip_scribe
base o=gouv, c=fr
nss_override_attribute_value shadowMax 9999
" > /etc/ldap.conf

########################################################################
# activation des groupes des users du ldap
########################################################################
echo "Name: activate /etc/security/group.conf
Default: yes
Priority: 900
Auth-Type: Primary
Auth:
        required                        pam_group.so use_first_pass" > /usr/share/pam-configs/my_groups

########################################################################
#auth ldap
########################################################################
echo "[open_ldap]
nss_passwd=passwd:  files ldap
nss_group=group: files ldap
nss_shadow=shadow: files ldap
nss_netgroup=netgroup: nis
" > /etc/auth-client-config/profile.d/open_ldap

########################################################################
#application de la conf nsswitch
########################################################################
auth-client-config -t nss -p open_ldap

########################################################################
#modules PAM mkhomdir pour pam-auth-update
########################################################################
echo "Name: Make Home directory
Default: yes
Priority: 128
Session-Type: Additional
Session:
       optional                        pam_mkhomedir.so silent" > /usr/share/pam-configs/mkhomedir

grep "auth    required     pam_group.so use_first_pass"  /etc/pam.d/common-auth  >/dev/null
if [ $? == 0 ]
then
  echo "/etc/pam.d/common-auth Ok"
else
  echo  "auth    required     pam_group.so use_first_pass" >> /etc/pam.d/common-auth
fi

########################################################################
# mise en place de la conf pam.d
########################################################################
pam-auth-update consolekit ldap libpam-mount unix mkhomedir my_groups --force

########################################################################
# mise en place des groupes pour les users ldap dans /etc/security/group.conf
########################################################################
grep "*;*;*;Al0000-2400;floppy,audio,cdrom,video,plugdev,scanner" /etc/security/group.conf  >/dev/null; if [ $? != 0 ];then echo "*;*;*;Al0000-2400;floppy,audio,cdrom,video,plugdev,scanner" >> /etc/security/group.conf; else echo "group.conf ok";fi

########################################################################
#on remet debconf dans sa conf initiale
########################################################################
export DEBIAN_FRONTEND="dialog"
export DEBIAN_PRIORITY="high"

########################################################################
#parametrage du script de demontage du netlogon pour lightdm
########################################################################
touch /etc/lightdm/logonscript.sh
grep "if mount | grep -q \"/tmp/netlogon\" ; then umount /tmp/netlogon ;fi" /etc/lightdm/logonscript.sh  >/dev/null
if [ $? == 0 ]
then
  echo "Presession Ok"
else
  echo "if mount | grep -q \"/tmp/netlogon\" ; then umount /tmp/netlogon ;fi" >> /etc/lightdm/logonscript.sh
fi
chmod +x /etc/lightdm/logonscript.sh

touch /etc/lightdm/logoffscript.sh
echo "sleep 2 \
umount -f /tmp/netlogon \ 
umount -f \$HOME
" > /etc/lightdm/logoffscript.sh
chmod +x /etc/lightdm/logoffscript.sh

# echo "GVFS_DISABLE_FUSE=1" >> /etc/environment

########################################################################
#Paramétrage pour remplir pam_mount.conf
########################################################################

eclairng="<volume user=\"*\" fstype=\"cifs\" server=\"$ip_scribe\" path=\"eclairng\" mountpoint=\"/media/Serveur_Scribe\" />"
grep "/media/Serveur_Scribe" /etc/security/pam_mount.conf.xml  >/dev/null
if [ $? != 0 ]
then
  sed -i "/<\!-- Volume definitions -->/a\ $eclairng" /etc/security/pam_mount.conf.xml
else
  echo "eclairng deja present"
fi

homes="<volume user=\"*\" fstype=\"cifs\" server=\"$ip_scribe\" path=\"perso\" mountpoint=\"~/Documents\" />"
grep "mountpoint=\"~\"" /etc/security/pam_mount.conf.xml  >/dev/null
if [ $? != 0 ]
then sed -i "/<\!-- Volume definitions -->/a\ $homes" /etc/security/pam_mount.conf.xml
else
  echo "homes deja present"
fi

netlogon="<volume user=\"*\" fstype=\"cifs\" server=\"$ip_scribe\" path=\"netlogon\" mountpoint=\"/tmp/netlogon\"  sgrp=\"DomainUsers\" />"
grep "/tmp/netlogon" /etc/security/pam_mount.conf.xml  >/dev/null
if [ $? != 0 ]
then
  sed -i "/<\!-- Volume definitions -->/a\ $netlogon" /etc/security/pam_mount.conf.xml
else
  echo "netlogon deja present"
fi

grep "<cifsmount>mount -t cifs //%(SERVER)/%(VOLUME) %(MNTPT) -o \"noexec,nosetuids,mapchars,cifsacl,serverino,nobrl,iocharset=utf8,user=%(USER),uid=%(USERUID)%(before=\\",\\" OPTIONS)\"</cifsmount>" /etc/security/pam_mount.conf.xml  >/dev/null
if [ $? != 0 ]
then
  sed -i "/<\!-- pam_mount parameters: Volume-related -->/a\ <cifsmount>mount -t cifs //%(SERVER)/%(VOLUME) %(MNTPT) -o \"noexec,nosetuids,mapchars,cifsacl,serverino,nobrl,iocharset=utf8,user=%(USER),uid=%(USERUID)%(before=\\",\\" OPTIONS)\"</cifsmount>" /etc/security/pam_mount.conf.xml
else
  echo "mount.cifs deja present"
fi

########################################################################
#/etc/profile
########################################################################
echo "
export LC_ALL=fr_FR.utf8
export LANG=fr_FR.utf8
export LANGUAGE=fr_FR.utf8
" >> /etc/profile

########################################################################
#ne pas creer les dossiers par defaut dans home
########################################################################
sed -i "s/enabled=True/enabled=False/g" /etc/xdg/user-dirs.conf

########################################################################
# les profs peuvent sudo
########################################################################
grep "%professeurs ALL=(ALL) ALL" /etc/sudoers > /dev/null
if [ $?!=0 ]
then
  sed -i "/%admin ALL=(ALL) ALL/a\%professeurs ALL=(ALL) ALL" /etc/sudoers
  sed -i "/%admin ALL=(ALL) ALL/a\%DomainAdmins ALL=(ALL) ALL" /etc/sudoers
else
  echo "prof deja dans sudo"
fi

########################################################################
#parametrage du lightdm.conf
#activation du pave numerique par greeter-setup-script=/usr/bin/numlockx on
########################################################################
echo "[SeatDefaults]
    user-session=ubuntu
    allow-guest=false
    greeter-show-manual-login=true
    greeter-hide-users=true
    session-setup-script=/etc/lightdm/logonscript.sh
    session-cleanup-script=/etc/lightdm/logoffscript.sh
    greeter-setup-script=/usr/bin/numlockx on" > /etc/lightdm/lightdm.conf


#######################################################
#Paramétrage des paramètres Proxy pour tout le système
#######################################################
if  [ "$ip_proxy" != "" ] || [ $port_proxy != "" ] ; then

  echo "Paramétrage du proxy $ip_proxy:$port_proxy" 

#Paramétrage des paramètres Proxy pour Gnome
#######################################################
  echo "[org.gnome.system.proxy]
mode='manual'
use-same-proxy=true
ignore-hosts=$proxy_gnome_noproxy
[org.gnome.system.proxy.http]
host='$ip_proxy'
port=$port_proxy
[org.gnome.system.proxy.https]
host='$ip_proxy'
port=$port_proxy
" >> /usr/share/glib-2.0/schemas/my-defaults.gschema.override

  glib-compile-schemas /usr/share/glib-2.0/schemas

#Paramétrage du Proxy pour le systeme
######################################################################
echo "http_proxy=http://$ip_proxy:$port_proxy/
https_proxy=http://$ip_proxy:$port_proxy/
ftp_proxy=http://$ip_proxy:$port_proxy/
no_proxy=\"$proxy_env_noproxy\"" >> /etc/environment

#Paramétrage du Proxy pour apt
######################################################################
echo "Acquire::http::proxy \"http://$ip_proxy:$port_proxy/\";
Acquire::ftp::proxy \"ftp://$ip_proxy:$port_proxy/\";
Acquire::https::proxy \"https://$ip_proxy:$port_proxy/\";" > /etc/apt/apt.conf.d/20proxy

#Permettre d'utiliser la commande add-apt-repository derriere un Proxy
######################################################################
echo "Defaults env_keep = https_proxy" >> /etc/sudoers

fi

########################################################################
#suppression de l'envoi des rapport d'erreurs
########################################################################
echo "enabled=0" >/etc/default/apport

########################################################################
#suppression de l'applet network-manager
########################################################################
mv /etc/xdg/autostart/nm-applet.desktop /etc/xdg/autostart/nm-applet.old

########################################################################
#suppression du menu messages
########################################################################
apt-get remove indicator-messages -y


########################################################################
# Création du profil par défaut via /etc/skel (bureau customisé)
########################################################################
wget http://nux87.online.fr/xubuntu-customise/skel_custom.tar.gz
tar xzvf skel_custom.tar.gz -C /etc
rm -rf skel_custom.tar.gz

# Wallpaper
wget http://nux87.online.fr/xubuntu-customise/xubuntu-wallpaper.png
mv -f xubuntu-wallpaper.png /usr/share/xfce4/backdrops/

########################################################################
#nettoyage station avant clonage
########################################################################
apt-get -y autoremove --purge
apt-get -y clean

########################################################################
#FIN
########################################################################
echo "C'est fini ! Un reboot est nécessaire..."
read -p "Voulez-vous redémarrer immédiatement ? [O/n] " rep_reboot
if [ "$rep_reboot" = "O" ] || [ "$rep_reboot" = "o" ] || [ "$rep_reboot" = "" ] ; then
  reboot
fi
