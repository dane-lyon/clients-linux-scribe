#!/bin/bash
# version 2.4.0

# Testé & validé pour les distributions suivantes :
################################################
# - Ubuntu 20.04 (Gnome Shell)
# - Xubuntu 20.04 (Xfce)
# - Ubuntu Mate 20.04 (Mate)
# - Linux Mint 20 (Cinnamon/Mate/Xfce)

###### Intégration pour un Scribe 2.3, 2.4, 2.5 et 2.6 en mode NT ###### 

#######################################################
# Rappel des problèmes connus
#######################################################

### Si vous avez un Scribe en version supérieure à 2.3, pour avoir les partages vous avez ceci à faire :
# https://dane.ac-lyon.fr/spip/Client-Linux-activer-les-partages

# --------------------------------------------------------------------------------------------------------------------


## Liste des contributeurs au script :
# Christophe Deze - Rectorat de Nantes
# Cédric Frayssinet - Mission Tice Ac-lyon
# Xavier Garel - Mission Tice Ac-lyon
# Simon Bernard - Technicien Ac-Lyon
# Olivier Calpetard - Académie de la Réunion
# Lseys - Entreprise Cadoles

# Proxy system
###########################################################################
#Paramétrage par défaut
#Changez les valeurs, ainsi, il suffira de taper 'entrée' à chaque question
###########################################################################
scribe_def_ip="192.168.220.10"
proxy_def_ip="172.16.0.252"
proxy_def_port="3128"
proxy_gnome_noproxy="[ 'localhost', '127.0.0.0/8', '172.16.0.0/16', '192.168.0.0/16' ]"
proxy_env_noproxy="localhost,127.0.0.1,192.168.0.0/16,172.16.0.0/16"
pagedemarragepardefaut="https://www.qwant.com/"

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
  version=trusty # Ubuntu 14.04 / Linux Mint 17/17.3
fi

if [ "$DISTRIB_RELEASE" = "16.04" ] || [ "$DISTRIB_RELEASE" = "18" ] || [ "$DISTRIB_RELEASE" = "18.3" ] || [ "$(echo "$DISTRIB_RELEASE" | cut -c -3)" = "0.4" ] ; then
  version=xenial # Ubuntu 16.04 / Linux Mint 18/18.3 / Elementary OS 0.4.x
fi

if [ "$DISTRIB_RELEASE" = "18.04" ] || [ "$DISTRIB_RELEASE" = "19" ] || [ "$DISTRIB_RELEASE" = "5.0" ] ; then 
  version=bionic # Ubuntu 18.04 / Mint 19 / Elementary OS 5.0
fi

if [ "$DISTRIB_RELEASE" = "20.04" ] || [ "$DISTRIB_RELEASE" = "20" ] ; then 
  version=focal # Ubuntu 20.04 / Mint 20 
fi

########################################################################
# Vérification de version
########################################################################

if [ "$version" != "trusty" ] && [ "$version" != "xenial" ] && [ "$version" != "bionic" ] && [ "$version" != "focal" ] ; then
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
### Utilisation du Script Esubuntu ? désactivation pour ubuntu 20.04
##############################################################################
if [ "$DISTRIB_RELEASE" = "20.04" ] || [ "$DISTRIB_RELEASE" = "20" ] ; 
then 
  esubuntu = "N"
else
  read -p "Voulez-vous activer le script Esubuntu (cf doc avant : https://frama.link/esub) ? Attention non portée pour ubuntu 20.04 [o/N] :" esubuntu
fi
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
if [[ "$ip_proxy" != "" ]] && [[ $port_proxy != "" ]] ; then

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
apt update ; apt full-upgrade -y

# Ajout de Net-tools pour ifconfig en 18.04 et futures versions
apt install -y net-tools

####################################################
# Téléchargement + Mise en place de Esubuntu (si activé)
####################################################
if [ "$esubuntu" = "O" ] || [ "$esubuntu" = "o" ] ; then 
  # Téléchargement des paquets
  #wget --no-check-certificate https://codeload.github.com/dane-lyon/Esubuntu/zip/master #(pose problème lors des tests)
  ## Précision : en raison des problèmes que pose l'https pour le téléchargement dans les établissements, l'archive est ré-hebergé sur un ftp free :
  wget http://nux87.free.fr/pour_script_integrdom/Esubuntu-master.zip
  
 # Déplacement/extraction de l'archive + lancement par la suite
  unzip Esubuntu-master.zip ; rm -r Esubuntu-master.zip ; chmod -R +x Esubuntu-master
  ./Esubuntu-master/install_esubuntu.sh
  # Mise en place des wallpapers pour les élèves, profs, admin 
  wget http://nux87.free.fr/esu_ubuntu/wallpaper.zip
  #Lien alternatif : https://github.com/dane-lyon/fichier-de-config/raw/master/wallpaper.zip
  unzip wallpaper.zip ; rm -r wallpaper.zip
  mv wallpaper /usr/share/
fi

########################################################################
#Mettre la station à l'heure à partir du serveur Scribe
########################################################################
apt install -y ntpdate ;
ntpdate $ip_scribe

########################################################################
#installation des paquets nécessaires
#numlockx pour le verrouillage du pavé numérique
#unattended-upgrades pour forcer les mises à jour de sécurité à se faire
########################################################################
apt install -y ldap-auth-client libpam-mount cifs-utils nscd numlockx unattended-upgrades

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
#auth ldap avec changement de fichier sur les version 20.04 et 20(Mint) => /etc/nsswitch.conf
########################################################################
 
if [ "$DISTRIB_RELEASE" = "20.04" ] || [ "$DISTRIB_RELEASE" = "20" ] ; then 
echo "# pre_auth-client-config # passwd:         compat systemd
passwd:  files ldap
# pre_auth-client-config # group:          compat systemd
group: files ldap
# pre_auth-client-config # shadow:         compat
shadow: files ldap
gshadow:        files

hosts:          files mdns4_minimal [NOTFOUND=return] dns myhostname
networks:       files

protocols:      db files
services:       db files
ethers:         db files
rpc:            db files

# pre_auth-client-config # netgroup:       nis
netgroup: nis
" > /etc/nsswitch.conf
else
echo "[open_ldap]
nss_passwd=passwd:  files ldap
nss_group=group: files ldap
nss_shadow=shadow: files ldap
nss_netgroup=netgroup: nis
" > /etc/auth-client-config/profile.d/open_ldap
fi

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
grep "*;*;*;Al0000-2400;floppy,audio,cdrom,video,plugdev,scanner,dialout" /etc/security/group.conf  >/dev/null; 

if [ $? != 0 ] ; then 
  echo "*;*;*;Al0000-2400;floppy,audio,cdrom,video,plugdev,scanner,dialout" >> /etc/security/group.conf 
  else echo "group.conf ok"
fi

########################################################################
#on remet debconf dans sa conf initiale
########################################################################
export DEBIAN_FRONTEND="dialog"
export DEBIAN_PRIORITY="high"

########################################################################
#paramétrage du script de démontage du netlogon pour lightdm 
########################################################################
if [ "$(which lightdm)" = "/usr/sbin/lightdm" ] ; then #Si lightDM présent
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


# Modification ancien gestionnaire de session MDM
if [ "$(which mdm)" = "/usr/sbin/mdm" ] ; then # si MDM est installé (ancienne version de Mint <17.2)
  cp /etc/mdm/mdm.conf /etc/mdm/mdm_old.conf #backup du fichier de config de mdm
  wget --no-check-certificate https://raw.githubusercontent.com/dane-lyon/fichier-de-config/master/mdm.conf ; mv -f mdm.conf /etc/mdm/ ; 
fi

# Si Ubuntu Mate
if [ "$(which caja)" = "/usr/bin/caja" ] ; then
  apt purge -y hexchat transmission-gtk ubuntu-mate-welcome cheese pidgin rhythmbox
  snap remove ubuntu-mate-welcome
fi

# Si Lubuntu (lxde)
if [ "$(which pcmanfm)" = "/usr/bin/pcmanfm" ] ; then
  apt purge -y abiword gnumeric pidgin transmission-gtk sylpheed audacious guvcview ;
fi

########################################################################
# Spécifique Gnome Shell
########################################################################
if [ "$(which gnome-shell)" = "/usr/bin/gnome-shell" ] ; then  # si GS installé

# Désactiver userlist pour GDM
echo "user-db:user
system-db:gdm
file-db:/usr/share/gdm/greeter-dconf-defaults" > /etc/dconf/profile/gdm

mkdir /etc/dconf/db/gdm.d
echo "[org/gnome/login-screen]
# Do not show the user list
disable-user-list=true" > /etc/dconf/db/gdm.d/00-login-screen

#prise en compte du changement
dconf update

# Suppression icone Amazon
apt purge -y ubuntu-web-launchers 
apt purge -y gnome-initial-setup

# Remplacement des snaps par défauts par la version apt (plus rapide)
snap remove gnome-calculator gnome-characters gnome-logs gnome-system-monitor
apt install gnome-calculator gnome-characters gnome-logs gnome-system-monitor -y 
apt install hxtools

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

groupes="<volume user=\"*\" fstype=\"cifs\" server=\"$ip_scribe\" path=\"groupes\" mountpoint=\"~/Groupes\" />"
grep "mountpoint=\"~\"" /etc/security/pam_mount.conf.xml  >/dev/null
if [ $? != 0 ]
then
  sed -i "/<\!-- Volume definitions -->/a\ $groupes" /etc/security/pam_mount.conf.xml
else
  echo "groupes déjà présent"
fi

commun="<volume user=\"*\" fstype=\"cifs\" server=\"$ip_scribe\" path=\"commun\" mountpoint=\"~/commun\" />"
grep "mountpoint=\"~\"" /etc/security/pam_mount.conf.xml  >/dev/null
if [ $? != 0 ]
then
  sed -i "/<\!-- Volume definitions -->/a\ $commun" /etc/security/pam_mount.conf.xml
else
  echo "commun déjà présent"
fi

professeurs="<volume user=\"*\" fstype=\"cifs\" server=\"$ip_scribe\" path=\"professeurs\" mountpoint=\"~/professeurs\" />"
grep "mountpoint=\"~\"" /etc/security/pam_mount.conf.xml  >/dev/null
if [ $? != 0 ]
then
  sed -i "/<\!-- Volume definitions -->/a\ $professeurs" /etc/security/pam_mount.conf.xml
else
  echo "professeurs déjà présent"
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
apt purge -y aisleriot gnome-mahjongg ;

# Pour être sûr que les paquets suivant (parfois présent) ne sont pas installés :
apt purge -y pidgin transmission-gtk gnome-mines gnome-sudoku blueman abiword gnumeric thunderbird ;
apt purge -y mintwelcome ;

########################################################################
#suppression de l'envoi des rapport d'erreurs
########################################################################
echo "enabled=0" > /etc/default/apport

########################################################################
#suppression de l'applet network-manager
########################################################################
#mv /etc/xdg/autostart/nm-applet.desktop /etc/xdg/autostart/nm-applet.old

########################################################################
#suppression du menu messages
########################################################################
apt purge -y indicator-messages 

# Changement page d'accueil firefox
echo "user_pref(\"browser.startup.homepage\", \"$pagedemarragepardefaut\");" >> /usr/lib/firefox/defaults/pref/channel-prefs.js

if [ "$DISTRIB_RELEASE" = "20.04" ] || [ "$DISTRIB_RELEASE" = "20" ] ; then 
  if [ "$DISTRIB_RELEASE" = "20" ] ; then
  echo "user_pref(\"browser.startup.homepage\", \"$pagedemarragepardefaut\");" >> /etc/firefox/syspref.js
  echo "lockPref(\"browser.startup.homepage\", \"$pagedemarragepardefaut\" );" >> /etc/firefox/syspref.js
  echo "user_pref(\"browser.startup.homepage\", \"$pagedemarragepardefaut\");" >> /usr/lib/firefox/defaults/pref/all-user.js
  echo "lockPref(\"browser.startup.homepage\", \"$pagedemarragepardefaut\" );" >> /usr/lib/firefox/defaults/pref/all-user.js
  sed -i 's/^browser\.startup\.homepage=.*$/browser.startup.homepage="http:\/\/lite.qwant.com"/' /usr/share/ubuntu-system-adjustments/firefox/distribution.ini 
  fi
######################################################################################################################
# Ci-dessus pour Mint n'ayant pas une version de firefox > 80 
# Ubuntu emplacement choisi par les distribution pour forcer les page
# /usr/lib/firefox/defaults/pref/vendor.js
# /usr/lib/chromium-browser/master_preferences && sudo rm /usr/lib/firefox/ubuntumate.cfg
# /usr/lib/firefox/defaults/pref/all-ubuntumate.js
# CI DESSOUS utilisation de https://github.com/mozilla/policy-templates/blob/master/README.md#homepage compatible firefox V 80 +
# écriture dans les deux emplacements possible (cf doc) mais fonctione avec /etc/firefox/policies/policies
######################################################################################################################
mkdir /etc/firefox/policies
echo "{
  \"policies\": {
    \"Homepage\": {
      \"URL\": \"$pagedemarragepardefaut\",
      \"Locked\": true,
      \"StartPage\": \"homepage\" 
    },
  \"OverrideFirstRunPage\": \"\"
  }
}" >> /etc/firefox/policies/policies.json

#cp /etc/firefox/policies.json /usr/lib/firefox/distribution/policies.json 

fi

# Logiciels utiles
apt install -y vim htop

# Lecture DVD sur Ubuntu 16.04 et supérieur ## répondre oui aux question posés...
#apt install -y libdvd-pkg ; dpkg-reconfigure libdvd-pkg

# Lecture DVD sur Ubuntu 14.04
if [ "$version" = "trusty" ] ; then
  apt install -y libdvdread4 && bash /usr/share/doc/libdvdread4/install-css.sh
fi

# Résolution problème dans certains cas uniquement pour Trusty (exemple pour lancer gedit directement avec : sudo gedit)
if [ "$version" = "trusty" ] ; then
  echo 'Defaults        env_keep += "DISPLAY XAUTHORITY"' >> /etc/sudoers
fi

# Spécifique base 16.04 ou 18.04 : pour le fonctionnement du dossier /etc/skel 
if [ "$version" = "xenial" ] || [ "$version" = "bionic" ] ; then
  sed -i "30i\session optional        pam_mkhomedir.so" /etc/pam.d/common-session
fi

# Spécifique base 20.04 ou 20 : pour le fonctionnement du dossier skel, ajouter dans /etc/skel ce qui doit être appliqué aux profil
if [ "$DISTRIB_RELEASE" = "20.04" ] || [ "$DISTRIB_RELEASE" = "20" ] ; then 
  sed -i "30i\session optional        pam_umask=0022 skel=/etc/skel" /etc/pam.d/common-session 
  sed -i "30i\session optional        pam_mkhomedir.so" /etc/pam.d/common-session
fi

if [ "$version" = "bionic" ] ; then
  # Création de raccourci sur le bureau + dans dossier utilisateur (pour la 18.04 uniquement) pour l'accès aux partages (commun+perso+lespartages)
  wget http://nux87.free.fr/pour_script_integrdom/skel.tar.gz
  tar -xzf skel.tar.gz -C /etc/
  rm -f skel.tar.gz
fi

# Suppression de notification de mise à niveau 
sed -r -i 's/Prompt=lts/Prompt=never/g' /etc/update-manager/release-upgrades

# Enchainer sur un script de Postinstallation sur demande (facultatif)
if [ "$1" = "pi" ] ; then # Pour 14.04/16.04/18.04
  wget --no-check-certificate https://raw.githubusercontent.com/dane-lyon/clients-linux-scribe/master/ubuntu-et-variantes-postinstall.sh 
  chmod +x ubuntu-et-variantes-postinstall.sh ; ./ubuntu-et-variantes-postinstall.sh ; rm -f ubuntu*.sh ;
fi

if [ "$1" = "extra" ] ; then # Pour 18.04 uniquement
  wget --no-check-certificate https://raw.githubusercontent.com/simbd/Scripts_Ubuntu/master/Ubuntu18.04_Bionic_Postinstall.sh
  chmod +x Ubuntu18.04_Bionic_Postinstall.sh ; ./Ubuntu18.04_Bionic_Postinstall.sh ; rm -f Ubuntu*.sh ;
fi

########################################################################
#nettoyage station avant clonage
########################################################################
apt-get -y autoremove --purge ; apt-get -y clean ; clear

########################################################################
#FIN
########################################################################
echo "C'est fini ! Un reboot est nécessaire..."
read -p "Voulez-vous redémarrer immédiatement ? [O/n] " rep_reboot
if [ "$rep_reboot" = "O" ] || [ "$rep_reboot" = "o" ] || [ "$rep_reboot" = "" ] ; then
  reboot
fi
