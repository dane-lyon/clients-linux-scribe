#!/bin/bash
#v1.1

# Le but de ce script est de faire l'inverse du script d'intégration au domaine c'est à dire :
# Retirer du domaine un Ubuntu (ou variante) qui a été précédemment intégré avec le script d'intégration.


#############################################
# Run using sudo, of course.
#############################################
if [ "$UID" -ne "0" ]
then
  echo "Il faut etre root pour executer ce script. ==> sudo "
  exit 
fi 


apt-get purge -y ldap-auth-client libpam-mount cifs-utils nscd numlockx unattended-upgrades
rm -f /etc/ldap.conf
rm -f /usr/share/pam-configs/my_groups
rm -f /etc/auth-client-config/profile.d/open_ldap
rm -f /usr/share/pam-configs/mkhomedir
rm -f /etc/lightdm/logonscript.sh
rm -f /etc/lightdm/logoffscript.sh
rm -f /usr/share/lightdm/lightdm.conf.d/50-no-guest.conf
sed -i "s/enabled=False/enabled=True/g" /etc/xdg/user-dirs.conf

# Uniquement pour le cas ou Esubuntu a été installé 
apt-get remove -y zenity conky
rm -rf /usr/local/upkg_client
rm -f /etc/xdg/autostart/message_scribe.desktop
rm -f /etc/xdg/autostart/scribe_background.desktop
rm -f /etc/GM_ESU
rm -f /etc/lightdm/groupe.sh
echo "" > /etc/crontab #remplacement du contenu d'esubuntu par du contenu vide


echo "Désintégration terminé"
read -p "Il est fortement recommandé de redémarrer, voulez-vous le faire immédiatement ? [O/n] " rep_reboot
if [ "$rep_reboot" = "O" ] || [ "$rep_reboot" = "o" ] || [ "$rep_reboot" = "" ] ; then
  reboot
fi
