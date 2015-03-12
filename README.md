## Scripts pour Client Scribe (x)Ubuntu 12.04 ou 14.04 

Ce **script** permet d'intégrer des clients Gnu/Linux dans un environnement Eole-Scribe 2.2 ou 2.3. Les clients supportés sont les suivants :
- Ubuntu (Environnement Unity) 12.04 et 14.04
- Xubuntu (Environnement XFCE) 14.04
- Lubuntu (Environnement LXDE) 14.04
- Linux (Environnement Mate ou Cinammon) Mint 17 ou 17.1

Avant de lancer ce script, assurez-vous d'avoir installé toutes vos applications, puis vous pouvez cloner vos postes
avec la solution libre [OSCAR](http://oscar.crdp-lyon.fr/wiki/)

  - Télécharger le script, exemple pour le client Ubuntu 14.04 : 
	wget https://raw.githubusercontent.com/dane-lyon/clients-linux-scribe/master/client_scribe_ubuntu_14.04.sh
  - Se placer dans le répertoire courant puis lancer les commandes :

	chmod +x client_scribe_ubuntu_14.04.sh

	sudo ./client_scribe_ubuntu_14.04.sh

###**Remarques :** 

#### Script de post-installation

Pour gagner du temps lors de la création du poste modèle, on pourra utiliser un script de post-installation qui installera le système avec toutes les applications souhaitées : https://github.com/dane-lyon/clients-linux-scribe/blob/master/ubuntu_14.04_postinstall.py


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
