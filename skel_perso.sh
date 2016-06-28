#!/bin/bash

# Ce script est là pour automatiser la copie du profil en cours dans le répertoire skel afin d'avoir un bureau customisé
#homogène sur l'ensemble du parc. Vous devez donc avoir personnalisé le bureau comme vous le souhaitez avant d'appliquer
#ce script. 

# Doit impérativement être lancé avec sudo !

#############################################
# Run using sudo, of course.
#############################################
if [ "$UID" -ne "0" ]
then
  echo "Il faut lancer ce script avec sudo => sudo ./skelperso.sh"
  exit 
fi

# On repart de 0 pour le skel pour être sûr
rm -rf /etc/skel ; mkdir /etc/skel

#############################################
# Copie votre profil
#############################################
#Bureau
cp -rf ~/Bureau /etc/skel/ ;
#.Config
mkdir /etc/skel/.config ;

#copie dossier
cp -rf ~/.config/autostart /etc/skel/.config/ ;
cp -rf ~/.config/dconf /etc/skel/.config/ ;
cp -rf ~/.config/gtk-2.0 /etc/skel/.config/ ;
cp -rf ~/.config/menus /etc/skel/.config/ ;
cp -rf ~/.config/mono.addins /etc/skel/.config/ ;
cp -rf ~/.config/plank /etc/skel/.config/ ;
cp -rf ~/.config/pulse /etc/skel/.config/ ;
cp -rf ~/.config/update-notifier /etc/skel/.config/ ;
cp -rf ~/.config/upstart /etc/skel/.config/ ;
cp -rf ~/.config/xfce4 /etc/skel/.config/ ;
cp -rf ~/.config/xfce4-session /etc/skel/.config/ ;
cp -rf ~/.config/gnome-control-center /etc/skel/.config/ ;

#copie fichiers
cp -f ~/.config/Trolltech.conf /etc/skel/.config/ ;
cp -f ~/.config/user-dirs.dirs /etc/skel/.config/ ;
cp -f ~/.config/user-dirs.locale /etc/skel/.config/ ;

#.gconf
mkdir /etc/skel/.gconf
cp -rf ~/.gconf/apps /etc/skel/.gconf/ 

#.local
mkdir /etc/skel/.local ; mkdir /etc/skel/.local/share
cp -rf ~/.local/share/applications /etc/skel/.local/share/

#divers
cp -f ~/.bash_logout /etc/skel/
cp -f ~/.bashrc /etc/skel/
cp -f ~/.profile /etc/skel/

#############################################
# Page par défaut Firefox (a décommenter si besoin)
#############################################
#echo "user_pref(\"browser.startup.homepage\", \"http://lite.qwant.com\");" >> /usr/lib/firefox/defaults/pref/channel-prefs.js
