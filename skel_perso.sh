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

#############################################
# Copie votre profil
#############################################
cp -rf ~/.config /etc/skel/ ;
cp -rf ~/.local /etc/skel/ ;
cp -rf ~/.gconf /etc/skel/ ;
cp -rf ~/Bureau /etc/skel/ ;
#cp -rf ~/Desktop /etc/skel/ ;

#############################################
# Page par défaut Firefox (a décommenter si besoin)
#############################################
#echo "user_pref(\"browser.startup.homepage\", \"http://lite.qwant.com\");" >> /usr/lib/firefox/defaults/pref/channel-prefs.js
