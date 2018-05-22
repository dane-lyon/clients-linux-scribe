## Scripts pour Client Scribe (x)Ubuntu 14.04, 16.04 et 18.04

Ce **script** permet d'intégrer des clients Gnu/Linux dans un environnement Eole-Scribe 2.3, 2.4, 2.5 ou 2.6 

Les clients supportés/testés avec les scripts sont les suivants :
- Ubuntu (Unity) 14.04, 16.04 et 18.04 (GS)
- Xubuntu (XFCE) 14.04, 16.04 et 18.04
- Lubuntu (LXDE) 14.04, 16.04 et (Lxde/LxQt) 18.04 
- Ubuntu Mate 16.04 et 18.04
- Ubuntu Budgie 18.04
- Linux Mint (Cinammon/Mate/Xfce) 17.X et 18.X (et probablement la future 19.X)
- Elementary OS (Pantheon) 0.4 (et probablement la future 5.0)

NB : Ce script intègre désormais Esubuntu (il vous posera la question au lancement du script si vous voulez l'utiliser ou pas, plus de précision ici : https://github.com/dane-lyon/clients-linux-scribe/blob/master/Esubuntu.md

Avant de lancer ce script, assurez-vous d'avoir installé toutes vos applications, puis vous pouvez cloner vos postes
avec la solution libre [OSCAR](http://oscar.crdp-lyon.fr/wiki/)

  - Télécharger le script le script d'intégration :
	
	<code>wget https://raw.githubusercontent.com/dane-lyon/clients-linux-scribe/master/ubuntu-et-variantes-integrdom.sh</code>

  - Se placer dans le répertoire courant puis lancer les commandes :
	
	<code>chmod +x ubuntu-et-variantes-integrdom.sh</code>

	<code>sudo ./ubuntu-et-variantes-integrdom.sh</code>
	
#### Important : en cas de problème de téléchargement

Si vous avez des difficultés pour télécharger les scripts depuis le serveur scribe (ce qui peux arriver en passant derrière un proxy en établissement), il faut rajouter le proxy en faisant :
<code>export https_proxy="ip_proxy:port_proxy"</code>
par exemple si votre serveur Amon est en 172.16.0.252 et avec le port 3128 :

<code>export https_proxy="172.16.0.252:3128"</code>

puis si vous avez le message suivant "Incapable d'établir une connexion SSL", il faut rajouter l'argument suivant : --no-check-certificate, ce qui donne par exemple :

<code>wget https://raw.githubusercontent.com/dane-lyon/clients-linux-scribe/master/ubuntu-et-variantes-integrdom.sh --no-check-certificate</code>

###**Remarques :** 

#### Script de post-installation

Pour gagner du temps lors de la création du poste modèle, on pourra utiliser ensuite le script de post-installation qui installera le système avec toutes les applications souhaitées : https://raw.githubusercontent.com/dane-lyon/clients-linux-scribe/master/ubuntu-et-variantes-postinstall.sh 

#### Partages

Si votre serveur Scribe est en version "2.4" , "2.5" ou "2.6", par défaut vous n'aurez pas les partages avec les clients linux (groupes, classes etc...), pour régler le problème, vous devez faire la manipulation suivante sur votre serveur :
https://dane.ac-lyon.fr/spip/Client-Linux-activer-les-partages

### Problèmes d'identifications possibles 

Pour ne pas avoir de problème d'identification, vérifier que :

- l'utilisateur a déjà changé une fois son mot de passe depuis un poste windows
OU
- le changement de mot de passe n'est pas demandé (case décochée dans l'ead pour l'utilisateur)

### Client Shell

De plus, il est conseillé que la case "client shell linux" soit cochée pour les utilisateurs dans l'EAD du scribe sinon, dans certains cas, l'authentification ne pourra avoir lieu.

#### Personnalisation des valeurs par défaut

Vous pouvez éditer les valeurs par défaut en début de script afin de les adapter à votre environnement.

#### Personnalisation des menus de l'environnement Unity

Pour personnaliser le menu d'Unity (sur les anciennes versions d'Ubuntu) à tous les utilisateurs, chercher dans le script ces lignes :

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

	<code>sudo glib-compile-schemas /usr/share/glib-2.0/schemas</code>

A noter que chaque élève ou enseignant pourra personnaliser son menu par la suite puisque le profil est local. La personnalisation sera, en revanche, propre à chaque poste.


Si vous ne savez pas quelle interface de bureau choisir, voici un aperçu des différentes variantes supportés :

## Ubuntu 16.04 :
![Ubuntu 16.04](http://pix.toile-libre.org/upload/original/1466589158.png)

## Xubuntu 16.04 :
![Xubuntu 16.04](http://pix.toile-libre.org/upload/original/1466589234.png)

## Lubuntu 16.04 :
![Lubuntu 16.04](http://pix.toile-libre.org/upload/original/1466589267.png)

## Ubuntu Mate 16.04 :
![Ubuntu Mate 16.04](http://pix.toile-libre.org/upload/original/1466589298.png)

## Linux Mint 18 :
![Linux Mint 18](http://pix.toile-libre.org/upload/original/1466589327.png)

## Ubuntu Budgie Remix 16.04 :
![Ubuntu Budgie 16.04](http://pix.toile-libre.org/upload/original/1508504494.png)

## Elementary OS 0.4 :
![Elementary OS 0.4](http://pix.toile-libre.org/upload/original/1508504624.png)
