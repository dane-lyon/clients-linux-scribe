
#!/bin/bash
# N'utilisez pas ce script si vous ne savez pas ce que vous faites !

# Avant de lancer ce script : merci de faire le nettoyage en supprimant dans votre cache tous les fichiers/dossiers que vous jugez inutiles (geogebra, libreoffice...)
# Une fois un profil-modèle établi, vous pouvez utiliser ce script pour copier dans /etc/skel pour s'appliquer à l'ensemble des utilisateurs.

#############################################
# Run using sudo, of course.
#############################################
if [ "$UID" -ne "0" ]
then
  echo "Il faut lancer ce script avec sudo => sudo ./script.sh"
  exit 
fi

rm -rf /etc/skel/*
cp -rf /home/$SUDO_USER/.config /etc/skel/
cp -f /home/$SUDO_USER/.* /etc/skel/
mkdir /etc/skel/Bureau /etc/skel/Images /etc/skel/Modèles /etc/skel/Musique /etc/skel/Téléchargements /etc/skel/Vidéos
