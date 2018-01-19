#!/bin/bash
# version 1.2

# Testé & validé pour les distributions suivantes :
################################################
# - Ubuntu 14.04 & 16.04 (Unity)
# - Xubuntu 14.04 & 16.04 (Xfce)
# - Lubuntu 14.04 & 16.04 (Lxde)
# - Ubuntu Mate 16.04 (Mate)
# - Ubuntu Budgie Remix 16.04 (Budgie)
# - Elementary OS 0.4.1 (Pantheon)
# - Linux Mint 17.X & 18.X (Cinnamon, Mate, Xfce)

# ATTENTION : La 18.04 ne semble pas compatible avec l'intégration au domaine (problème de boot ou dossiers partagés manquants !)

# Si vous activez "Esubuntu", la fonction de déport distant des wallpapers ne fonctionnera que sur Ubuntu/Unity 14.04/16.04 (pas les variantes)
# Pour Esubuntu, pack à uploader dans /netlogon/icones/{votre groupe esu} : https://github.com/dane-lyon/experimentation/raw/master/config_default.zip

###### Intégration pour un Scribe 2.3, 2.4, 2.5, 2.6 avec les clients basés sur Trusty et Xenial ###### 

#######################################################
# Rappel des problèmes connus
#######################################################

### Si vous avez un Scribe en version supérieure à 2.3, pour avoir les partages vous avez ceci à faire :
# https://dane.ac-lyon.fr/spip/Client-Linux-activer-les-partages

### Si vous utilisez Oscar pour le déploiement de poste, à partir de la 16.04LTS, ce n'est compatible qu'avec les versions 
#récentes d'Oscar mais pas les anciennes versions.

# --------------------------------------------------------------------------------------------------------------------

## Changelog :
# - paquet à installer smbfs remplacé par cifs-utils car il a changé de nom.
# - ajout groupe dialout
# - désinstallation de certains logiciels inutiles suivant les variantes
# - ajout fonction pour programmer l'extinction automatique des postes le soir
# - lecture dvd inclus
# - changement du thème MDM par défaut pour Mint (pour ne pas voir l'userlist)
# - ajout d'une ligne dans sudoers pour régler un problème avec GTK dans certains cas sur la 14.04
# - changement page d'acceuil Firefox
# - utilisation du Skel désormais compatible avec la 16.04
# - ajout variable pour contrôle de la version
# - suppression de la notification de mise à niveau (sinon par exemple en 14.04, s'affiche sur tous les comptes au démarrage)
# - prise en charge du script Esubuntu (crée par Olivier CALPETARD)

# --------------------------------------------------------------------------------------------------------------------


## Liste des contributeurs au script :
# Christophe Deze - Rectorat de Nantes
# Cédric Frayssinet - Mission Tice Ac-lyon
# Xavier Garel - Mission Tice Ac-lyon
# Simon Bernard - Technicien Ac-Lyon
# Olivier Calpetard - Académie de la Réunion

# Proxy system
###########################################################################
#Paramétrage par défaut
#Changez les valeurs, ainsi, il suffira de taper 'entrée' à chaque question
###########################################################################
scribe_def_ip="192.168.220.10"
proxy_def_ip="172.16.0.252"
proxy_def_port="3128"
proxy_gnome_noproxy="[ 'localhost', '127.0.0.0/8', '172.16.0.0/16', '192.168.0.0/16', '*.crdp-lyon.fr', '*.crdplyon.lan' ]"
proxy_env_noproxy="localhost,127.0.0.1,192.168.0.0/16,172.16.0.0/16,.crdp-lyon.fr,.crdplyon.lan"
pagedemarragepardefaut="https://lite.qwant.com"

#############################################
# Run using sudo, of course.
#############################################
if [ "$UID" -ne "0" ]
then
  echo "Il faut etre root pour executer ce script. ==> sudo "
  exit 
fi 

# Pour identifier le numéro de la version (14.04, 16.04...)
. /etc/lsb-release

# Affectation à la variable "version" suivant la variante utilisé

if [ "$DISTRIB_RELEASE" = "14.04" ] || [ "$DISTRIB_RELEASE" = "17" ] || [ "$DISTRIB_RELEASE" = "17.3" ] ; then
  version=trusty # Ubuntu 14.04 ou Linux Mint 17/17.3
fi

if [ "$DISTRIB_RELEASE" = "16.04" ] || [ "$DISTRIB_RELEASE" = "18" ] || [ "$DISTRIB_RELEASE" = "18.3" ] || [ "$(echo "$DISTRIB_RELEASE" | cut -c -3)" = "0.4" ] ; then
  version=xenial # Ubuntu 16.04 ou Linux Mint 18/18.3 ou Elementary OS 0.4.x
fi

if [ "$DISTRIB_RELEASE" = "18.04" ] ; then 
  version=bionic # Ubuntu 18.04 (ajouter Mint 19 + Eos 0.5 plus tard !)
fi

########################################################################
# Vérification de version
########################################################################

if [ "$version" != "trusty" ] && [ "$version" != "xenial" ] && [ "$version" != "bionic" ] ; then
  echo "Désolé, vous n'êtes pas sur une version compatible !"
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

###################################################
# cron d'extinction automatique à lancer ?
###################################################

echo "Pour terminer, voulez-vous activer l'extinction automatique des postes le soir ?"
echo "0 = non, pas d'extinction automatique le soir"
echo "1 = oui, extinction a 19H00"
echo "2 = oui, extinction a 20H00"
echo "3 = oui, extinction a 22H00"
read -p "Répondre par le chiffre correspondant (0,1,2,3) : " rep_proghalt

if [ "$rep_proghalt" = "1" ] ; then
        echo "0 19 * * * root /sbin/shutdown -h now" > /etc/cron.d/prog_extinction
        else if [ "$rep_proghalt" = "2" ] ; then
                echo "0 20 * * * root /sbin/shutdown -h now" > /etc/cron.d/prog_extinction
                else if [ "$rep_proghalt" = "3" ] ; then
                        echo "0 22 * * * root /sbin/shutdown -h now" > /etc/cron.d/prog_extinction
                     fi
             fi
fi

##############################################################################
### Utilisation du Script Esubuntu ?
##############################################################################
read -p "Voulez-vous activer le script Esubuntu (cf doc avant : https://frama.link/esub) ? [O/N] :" esubuntu

########################################################################
#rendre debconf silencieux
########################################################################
export DEBIAN_FRONTEND="noninteractive"
export DEBIAN_PRIORITY="critical"

########################################################################
#suppression de l'applet switch-user pour ne pas voir les derniers connectés # Uniquement pour Ubuntu / Unity
#paramétrage d'un laucher unity par défaut : nautilus, firefox, libreoffice, calculatrice, éditeur de texte et capture d'écran
########################################################################
if [ "$(which unity)" = "/usr/bin/unity" ] ; then  # si Ubuntu/Unity alors :

echo "[com.canonical.indicator.session]
user-show-menu=false
[org.gnome.desktop.lockdown]
disable-user-switching=true
disable-lock-screen=true
[com.canonical.Unity.Launcher]
favorites=[ 'nautilus-home.desktop', 'firefox.desktop','libreoffice-startcenter.desktop', 'gcalctool.desktop','gedit.desktop','gnome-screenshot.desktop' ]
" > /usr/share/glib-2.0/schemas/my-defaults.gschema.override

fi

#######################################################
#Paramétrage des paramètres Proxy pour tout le système
#######################################################
if [[ "$ip_proxy" != "" ]] || [[ $port_proxy != "" ]] ; then

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

#Paramétrage du Proxy pour le système
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

#Permettre d'utiliser la commande add-apt-repository derrière un Proxy
######################################################################
echo "Defaults env_keep = https_proxy" >> /etc/sudoers

fi

# Modification pour ne pas avoir de problème lors du rafraichissement des dépots avec un proxy
# cette ligne peut être commentée/ignorée si vous n'utilisez pas de proxy ou avec la 14.04.
echo "Acquire::http::No-Cache true;" >> /etc/apt/apt.conf
echo "Acquire::http::Pipeline-Depth 0;" >> /etc/apt/apt.conf


# Vérification que le système est bien à jour
apt-get update ; apt-get -y dist-upgrade

####################################################
# Téléchargement + Mise en place de Esubuntu (si activé)
####################################################
if [ "$esubuntu" = "O" ] || [ "$esubuntu" = "o" ] ; then  
  # Téléchargement des paquets
  wget http://nux87.online.fr/esu_ubuntu/esu_ubuntu.zip
  unzip esu_ubuntu.zip
  
  # Création du dossier upkg
  mkdir /usr/local/upkg_client/
  chmod -R 777 /usr/local/upkg_client

  # Installation de zenity et conky
  add-apt-repository -y ppa:vincent-c/conky #conky est backporté pour avoir une version récente quelque soit la distrib
  apt-get update
  apt-get install -y zenity conky

  # Copie des fichiers
  cp -rf ./esu_ubuntu/lightdm/* /etc/lightdm/
  chmod +x /etc/lightdm/*.sh
  cp -rf ./esu_ubuntu/xdg_autostart/* /etc/xdg/autostart/
  chmod +x /etc/xdg/autostart/message_scribe.desktop
  chmod +x /etc/xdg/autostart/scribe_background.desktop
  
  # Gestion du groupe
  #salle du pc
  echo "Veuillez entrer le groupe ESU de vos postes clients linux : "
  read salle
  echo "$salle" > /etc/GM_ESU

  # Lancement script prof_firefox
  chmod -R +x ./esu_ubuntu
  ./esu_ubuntu/firefox/prof_firefox.sh
  
  # Mise en place des wallpapers pour les élèves, profs, admin (pour bureau Unity)
  wget http://nux87.online.fr/esu_ubuntu/wallpaper.zip
  unzip wallpaper.zip
  mv wallpaper /usr/share/

  # Inscription de la tache upkg dans crontab
  echo "*/20 * * * * root /etc/lightdm/groupe.sh" > /etc/crontab
  
  # Si il reste encore une trace de cntlm dans xdg autostart :
  rm -f /etc/xdg/autostart/cntlm*
  
  # Modification de la valeur en dur à la fin du fichier background.sh pour correspondre au bon groupe ESU
  sed -i -e "s/posteslinux/$salle/g" /etc/lightdm/background.sh
fi


########################################################################
#Mettre la station à l'heure à partir du serveur Scribe
########################################################################
apt-get -y install ntpdate ;
ntpdate $ip_scribe

########################################################################
#installation des paquets nécessaires
#numlockx pour le verrouillage du pavé numérique
#unattended-upgrades pour forcer les mises à jour de sécurité à se faire
########################################################################
apt-get install -y ldap-auth-client libpam-mount cifs-utils nscd numlockx unattended-upgrades

########################################################################
# activation auto des mises à jour de sécurité
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
grep "*;*;*;Al0000-2400;floppy,audio,cdrom,video,plugdev,scanner,dialout" /etc/security/group.conf  >/dev/null; if [ $? != 0 ];then echo "*;*;*;Al0000-2400;floppy,audio,cdrom,video,plugdev,scanner,dialout" >> /etc/security/group.conf; else echo "group.conf ok";fi

########################################################################
#on remet debconf dans sa conf initiale
########################################################################
export DEBIAN_FRONTEND="dialog"
export DEBIAN_PRIORITY="high"

########################################################################
#paramétrage du script de démontage du netlogon pour lightdm 
########################################################################
if [ "$(which lightdm)" = "/usr/sbin/lightdm" ] ; then 
  touch /etc/lightdm/logonscript.sh
  grep "if mount | grep -q \"/tmp/netlogon\" ; then umount /tmp/netlogon ;fi" /etc/lightdm/logonscript.sh  >/dev/null
  if [ $? == 0 ] ; then
    echo "Présession Ok"
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

  ########################################################################
  #paramétrage du lightdm.conf
  #activation du pavé numérique par greeter-setup-script=/usr/bin/numlockx on
  ########################################################################
  echo "[SeatDefaults]
      allow-guest=false
      greeter-show-manual-login=true
      greeter-hide-users=true
      session-setup-script=/etc/lightdm/logonscript.sh
      session-cleanup-script=/etc/lightdm/logoffscript.sh
      greeter-setup-script=/usr/bin/numlockx on" > /usr/share/lightdm/lightdm.conf.d/50-no-guest.conf
fi

# echo "GVFS_DISABLE_FUSE=1" >> /etc/environment

########################################################################
# Modification Gestionnaire de session MDM Linux Mint
########################################################################
if [ "$(which mdm)" = "/usr/sbin/mdm" ] ; then # si MDM est installé (ancienne version de Mint <17.2)
  cp /etc/mdm/mdm.conf /etc/mdm/mdm_old.conf #backup du fichier de config de mdm
  wget --no-check-certificate https://raw.githubusercontent.com/dane-lyon/fichier-de-config/master/mdm.conf ; mv -f mdm.conf /etc/mdm/ ; 
fi

# Si Ubuntu Mate
if [ "$(which caja)" = "/usr/bin/caja" ] ; then
  apt-get -y purge hexchat transmission-gtk ubuntu-mate-welcome cheese pidgin rhythmbox ;
fi

# Si Lubuntu (lxde)
if [ "$(which pcmanfm)" = "/usr/bin/pcmanfm" ] ; then
  apt-get -y purge abiword gnumeric pidgin transmission-gtk sylpheed audacious guvcview ;
fi

########################################################################
#Paramétrage pour remplir pam_mount.conf
########################################################################

eclairng="<volume user=\"*\" fstype=\"cifs\" server=\"$ip_scribe\" path=\"eclairng\" mountpoint=\"/media/Serveur_Scribe\" />"
grep "/media/Serveur_Scribe" /etc/security/pam_mount.conf.xml  >/dev/null
if [ $? != 0 ]
then
  sed -i "/<\!-- Volume definitions -->/a\ $eclairng" /etc/security/pam_mount.conf.xml
else
  echo "eclairng déjà présent"
fi

homes="<volume user=\"*\" fstype=\"cifs\" server=\"$ip_scribe\" path=\"perso\" mountpoint=\"~/Documents\" />"
grep "mountpoint=\"~\"" /etc/security/pam_mount.conf.xml  >/dev/null
if [ $? != 0 ]
then sed -i "/<\!-- Volume definitions -->/a\ $homes" /etc/security/pam_mount.conf.xml
else
  echo "homes déjà présent"
fi

netlogon="<volume user=\"*\" fstype=\"cifs\" server=\"$ip_scribe\" path=\"netlogon\" mountpoint=\"/tmp/netlogon\"  sgrp=\"DomainUsers\" />"
grep "/tmp/netlogon" /etc/security/pam_mount.conf.xml  >/dev/null
if [ $? != 0 ]
then
  sed -i "/<\!-- Volume definitions -->/a\ $netlogon" /etc/security/pam_mount.conf.xml
else
  echo "netlogon déjà présent"
fi

grep "<cifsmount>mount -t cifs //%(SERVER)/%(VOLUME) %(MNTPT) -o \"noexec,nosetuids,mapchars,cifsacl,serverino,nobrl,iocharset=utf8,user=%(USER),uid=%(USERUID)%(before=\\",\\" OPTIONS)\"</cifsmount>" /etc/security/pam_mount.conf.xml  >/dev/null
if [ $? != 0 ]
then
  sed -i "/<\!-- pam_mount parameters: Volume-related -->/a\ <cifsmount>mount -t cifs //%(SERVER)/%(VOLUME) %(MNTPT) -o \"noexec,nosetuids,mapchars,cifsacl,serverino,nobrl,iocharset=utf8,user=%(USER),uid=%(USERUID)%(before=\\",\\" OPTIONS),vers=1.0\"</cifsmount>" /etc/security/pam_mount.conf.xml
else
  echo "mount.cifs déjà présent"
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
#ne pas créer les dossiers par défaut dans home
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
  echo "prof déjà dans sudo"
fi

# Suppression de paquet inutile sous Ubuntu/Unity
apt-get -y purge aisleriot gnome-mahjongg ;

# Pour être sûr que les paquets suivant (parfois présent) ne sont pas installés :
apt-get -y purge pidgin transmission-gtk gnome-mines gnome-sudoku blueman abiword gnumeric thunderbird mintwelcome ;


########################################################################
#suppression de l'envoi des rapport d'erreurs
########################################################################
echo "enabled=0" > /etc/default/apport

########################################################################
#suppression de l'applet network-manager
########################################################################
mv /etc/xdg/autostart/nm-applet.desktop /etc/xdg/autostart/nm-applet.old

########################################################################
#suppression du menu messages
########################################################################
apt-get -y purge indicator-messages 

# Changement page d'accueil firefox
echo "user_pref(\"browser.startup.homepage\", \"$pagedemarragepardefaut\");" >> /usr/lib/firefox/defaults/pref/channel-prefs.js

# Lecture DVD
apt-get -y install libdvdread4
bash /usr/share/doc/libdvdread4/install-css.sh

# Résolution problème GTK dans certains cas uniquement pour Trusty (exemple pour lancer gedit directement avec : sudo gedit)
if [ "$version" = "trusty" ] ; then
  echo 'Defaults        env_keep += "DISPLAY XAUTHORITY"' >> /etc/sudoers
fi

# Spécifique base 16.04 ou 18.04 : pour le fonctionnement du dossier /etc/skel 
if [ "$version" = "xenial" ] || [ "$version" = "bionic" ] ; then
  sed -i "30i\session optional        pam_mkhomedir.so" /etc/pam.d/common-session
fi

# Suppression de notification de mise à niveau 
sed -r -i 's/Prompt=lts/Prompt=never/g' /etc/update-manager/release-upgrades

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
