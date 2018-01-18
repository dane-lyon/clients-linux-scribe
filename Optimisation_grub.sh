#!/bin/bash
# Petite optimisation pour Grub demandée par Cedric.F
# Ne l'utilisez pas si vous ne savez pas ce que vous faites !

# Script à lancer avec sudo, vérification :
if [ "$UID" -ne "0" ]
then
  echo "Il faut etre root pour executer ce script. ==> sudo "
  exit 
fi 

# Réinstallation de Grub sur le premier disque
# On préselectionne Windows par défaut
# On affiche le Grub tout le temps
# On fait en sorte d'organiser les différentes lignes
# On met à jour la conf de Grub
grub-install /dev/sda &&
sed -ri 's/GRUB_DEFAULT=0/GRUB_DEFAULT=2/g' /etc/default/grub
sed -ri 's/GRUB_TIMEOUT=10/GRUB_TIMEOUT=-1/g' /etc/default/grub
mv /etc/grub.d/30_os-prober /etc/grub.d/11_os-prober
update-grub
