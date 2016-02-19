## Scripts pour Client Scribe (x)Ubuntu 12.04 ou 14.04 

Ce **script** permet d'intégrer des clients Gnu/Linux dans un environnement Eole-Scribe 2.3, 2.4 ou 2.5 

Les clients supportés sont les suivants :
- Ubuntu (Environnement Unity) 12.04 et 14.04
- Xubuntu (Environnement XFCE) 14.04
- Lubuntu (Environnement LXDE) 14.04
- Ubuntu Mate (environnement Mate) 14.04
- Linux Mint (Environnement Cinammon/Mate) 17.x

Avant de lancer ce script, assurez-vous d'avoir installé toutes vos applications, puis vous pouvez cloner vos postes
avec la solution libre [OSCAR](http://oscar.crdp-lyon.fr/wiki/)

  - Télécharger le script, exemple pour le client Ubuntu 14.04 : 
	wget https://raw.githubusercontent.com/dane-lyon/clients-linux-scribe/master/client_scribe_ubuntu_14.04.sh
  - Se placer dans le répertoire courant puis lancer les commandes :

	chmod +x client_scribe_ubuntu_14.04.sh

	sudo ./client_scribe_ubuntu_14.04.sh

###**Remarques :** 

#### Script de post-installation

Pour gagner du temps lors de la création du poste modèle, on pourra utiliser un script de post-installation qui installera le système avec toutes les applications souhaitées : https://github.com/dane-lyon/clients-linux-scribe/blob/master/ubuntu_14.04_postinstall.py (pour ubuntu)
https://raw.githubusercontent.com/dane-lyon/clients-linux-scribe/master/xubuntu14.04_postinstall.sh (pour xubuntu & les autres variantes)

#### Partages

Si votre serveur Scribe est en version "2.4" ou "2.5", par défaut vous n'aurez pas les partages avec les clients linux (groupes, classes etc...), pour régler le problème, vous devez faire la manipulation suivante sur votre serveur :
https://dane.ac-lyon.fr/spip/Client-Linux-activer-les-partages

### Problèmes d'identifications possibles 

Pour ne pas avoir de problème d'identification, vérifier que :

- l'utilisateur a déjà changé une fois son mot de passe depuis un poste windows
OU
- le changement de mot de passe n'est pas demandé (case décoché dans l'ead pour l'utilisateur)

De plus, pour certaines variantes (comme Linux Mint ou Ubuntu Mate par exemple), il est impératif que la case "client shell linux" soit coché pour les utilisateurs dans l'EAD du scribe sinon il y aura des problèmes d'accès.


#### Personnalisation des valeurs par défaut

vous pouvez éditer les valeurs par défaut en début de script afin de les adapter à votre environnement.

#### Personnalisation des menus

Pour personnaliser le menu à tous les utilisateurs, chercher dans le script ces lignes :

	echo "[com.canonical.indicator.session]
	user-show-menu=false
	[org.gnome.desktop.lockdown]
	disable-user-switching=true
	disable-lock-screen=true
	[com.canonical.Unity.Launcher]
	favorites=[ 'nautilus-home.desktop', 'firefox.desktop','libreoffice-startcenter.desktop', 'gcalctool.desktop','gedit.desktop','gnome-screenshot.desktop' ]
	" > /usr/share/glib-2.0/schemas/my-defaults.gschema.override

La ligne
	favorites=[ 'nautilus-home.desktop', 'firefox.desktop','libreoffice-startcenter.desktop','gcalctool.desktop','gedit.desktop','gnome-screenshot.desktop' ]
est à adapter en fonction de vos besoins :

Pour connaitre le nom des raccourcis, faire dans un terminal : ls /usr/share/applications/

Pour voir à quelle application cela correspond, avec l'explorateur, il faut se déplacer dans /usr/share/applications/

Pour appliquer les modifications, il faut lancer la commande :

	sudo glib-compile-schemas /usr/share/glib-2.0/schemas

A noter que chaque élève ou enseignant peut personnaliser son menu.

### TO DO :

- gestion centralisée des profils (navigateurs, session...)
- gestion des mises à jour centralisées des postes clients
