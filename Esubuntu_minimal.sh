#!/bin/bash
#v0.6

# Ce script contient uniquement la partie "Esubuntu" (cf doc : https://github.com/dane-lyon/experimentation/blob/master/README.md)
# Cela concerne uniquement les personnes qui ont déjà intégré leur poste via le script integrdom et qui veulent ajouter Esubuntu
# Si vous n'avez pas encore utilisé le script d'intégration, ce script est inutile car la partie "esubuntu" est maintenant incluse dans le script IntegrDom (avec choix au lancement)

# Téléchargement des paquets
wget --no-check-certificate https://codeload.github.com/dane-lyon/Esubuntu/zip/master ; mv master esubuntu.zip
unzip esubuntu.zip ; rm -r esubuntu.zip ; chmod -R +x Esubuntu-master
./Esubuntu-master/install_esubuntu.sh

# Mise en place des wallpapers pour les élèves, profs, admin (pour bureau Unity)
wget http://nux87.online.fr/esu_ubuntu/wallpaper.zip
#Lien alternatif : https://github.com/dane-lyon/fichier-de-config/raw/master/wallpaper.zip
unzip wallpaper.zip ; rm -r wallpaper.zip
mv wallpaper /usr/share/
