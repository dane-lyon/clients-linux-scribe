#!/bin/bash

# Script à lancer avec sudo, vérification :
if [ "$UID" -ne "0" ]
then
  echo "Il faut etre root pour executer ce script. ==> sudo "
  exit 
fi 

grub-install /dev/sda &&
sed -ri 's/GRUB_DEFAULT=0/GRUB_DEFAULT=2/g' /etc/default/grub
sed -ri 's/GRUB_TIMEOUT=10/GRUB_TIMEOUT=-1/g' /etc/default/grub
mv /etc/grub.d/30_os-prober /etc/grub.d/11_os-prober
update-grub
