#!/bin/bash
#v0.7

# Ce script contient uniquement la partie "Esubuntu" (cf doc : https://github.com/dane-lyon/experimentation/blob/master/README.md)
# Cela concerne uniquement les personnes qui ont déjà intégré leur poste via le script integrdom et qui veulent ajouter Esubuntu
# Si vous n'avez pas encore utilisé le script d'intégration, ce script est inutile car la partie "esubuntu" est maintenant incluse dans le script IntegrDom (avec choix au lancement)

# Téléchargement des paquets
#wget --no-check-certificate https://codeload.github.com/dane-lyon/Esubuntu/zip/master #(pose problème lors des tests)
## Précision : en raison des problèmes que pose l'https pour le téléchargement dans les établissements, l'archive est ré-hebergé sur un ftp free :
wget http://nux87.free.fr/pour_script_integrdom/Esubuntu-master.zip
  
# Déplacement/extraction de l'archive + lancement par la suite
unzip Esubuntu-master.zip ; rm -r Esubuntu-master.zip ; chmod -R +x Esubuntu-master
./Esubuntu-master/install_esubuntu.sh

# Mise en place des wallpapers pour les élèves, profs, admin (pour bureau Unity)
wget http://nux87.free.fr/esu_ubuntu/wallpaper.zip
#Lien alternatif : https://github.com/dane-lyon/fichier-de-config/raw/master/wallpaper.zip
unzip wallpaper.zip ; rm -r wallpaper.zip
mv wallpaper /usr/share/
