## Script pour Client Scribe (x)Ubuntu 20.04

Le script pour intégrer un client Linux Ubuntu 20.04 (Gnome Shell, Mate, Linux Mint et Xubuntu) dans un domaine NT Scribe 2.5 et 2.6 est disponible : https://github.com/dane-lyon/clients-linux-scribe/blob/master/ubuntu-et-variantes-integrdom_20_04.sh.

Concernant Scribe >= 2.8, il faut utiliser les scripts fournis par Eole : http://eole.ac-dijon.fr/documentations/2.8/completes/HTML/ModuleScribe/co/integration_1.html

Pour la post-installation d'un Ubuntu 20.04, nous vous conseillons ce script, mais attention à ne pas installer n'importe quoi : https://github.com/simbd/Ubuntu_20.04LTS_PostInstall


## Scripts pour Client Scribe (x)Ubuntu 14.04, 16.04 et 18.04

Les **scripts** ci-dessus permettent d'intégrer des clients Gnu/Linux dans un environnement Eole-Scribe 2.3, 2.4, 2.5 ou 2.6 

Les clients supportés/testés avec les scripts sont les suivants :
- Ubuntu (Unity) 14.04, 16.04 et 18.04 (GS)
- Xubuntu (XFCE) 14.04, 16.04 et 18.04
- Lubuntu (LXDE) 14.04, 16.04 et (Lxde/LxQt) 18.04 
- Ubuntu Mate 16.04 et 18.04
- Ubuntu Budgie 18.04
- Linux Mint (Cinammon/Mate/Xfce) 17.X, 18.X et 19.X
- Elementary OS (Pantheon) 0.4 (et probablement la future 5.0).

Ce script d'intégration n'est PAS compatible avec des distributions comme : Debian, Fedora, Solus, Manjaro

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

Si votre serveur Scribe est en version _2.4_ , _2.5_ ou _2.6_, par défaut vous n'aurez pas les partages avec les clients linux (groupes, classes etc...) ; pour régler le problème, vous devez ajouter le fichier <code>partage-linux.conf</code> dans le dossier <code>/etc/samba/conf.d/</code>

puis éditez ce fichier avec vim ou nano et ajoutez : 

<code>
	[eclairng]
	path = %H/.ftp
	comment = espace personnel
	read only = no
	browseable = no
	invalid users = nobody guest
	inherit permissions = yes
	inherit acls = yes
	create mask = 0664
	directory mask = 0775
	valid users = %U
	write list = %U
	guest ok = no
	hide files = /config_eole/
</code> 

Une fois la modification enregistré, il suffit de faire (ou programmer) un reconfigure pour prendre en compte le changement. 

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

#### Concernant l'intégration d'un client Linux Mint 19

L'intégration fonctionne mais par défaut l'écran de session LightDM n'est pas modifié pour saisir vous même le login, pour régler le problème c'est très simple : connectez vous avec un compte (compte local ou compte admin ou compte prof) de préférence avant l'intégration au domaine puis il faut aller dans le "centre de contrôle de Cinnamon" (paramètre système) puis en bas dans la section administration "Fenêtre de connexion", dans l'onglet "Utilisateurs", activer "Permettre la connexion manuelle" ainsi que "Cacher la liste des utilisateurs" (éventuellement désactiver aussi "Autoriser les invités à se connecter" si besoin). Si le pavé numérique n'est pas activé au démarrage, vous pouvez en profiter dans "Options" pour activer "Activer le verouillage du pavé numérique" (si l'option est grisé, installer le paquet "numlockx" avant).
Manipulation à faire avant le clonage de vos postes sinon il faudra refaire la manip sur chaque poste...

Enfin, si vous ne savez pas quelle interface de bureau choisir avec Ubuntu, voici un aperçu des différentes variantes supportés :

## Ubuntu 18.04 (Gnome-Shell) :
![Ubuntu 18.04](http://nux87.free.fr/wallpaper_githubdane/ubuntu1804GS.jpg)

## Xubuntu 18.04 (Xfce) :
![Xubuntu 18.04](http://nux87.free.fr/wallpaper_githubdane/xubuntu1804xfce.jpg)

## Lubuntu 18.04 (Lxde) :
![Lubuntu 18.04](http://nux87.free.fr/wallpaper_githubdane/lubuntu1804lxde.jpg)

## Ubuntu Mate 18.04 (Mate) :
![Ubuntu Mate 18.04](http://nux87.free.fr/wallpaper_githubdane/ubuntumate1804.jpg)

## Ubuntu Budgie 18.04 (Budgie) :
![Ubuntu Budgie 18.04](http://nux87.free.fr/wallpaper_githubdane/ubuntubudgie1804.jpg)

## Linux Mint 19 (Cinnamon) :
![Linux Mint 19](http://nux87.free.fr/wallpaper_githubdane/linuxmint19cinnamon.jpg)

## Elementary OS 0.4 (PantheonUI):
![Elementary OS 0.4](http://nux87.free.fr/wallpaper_githubdane/elementaryos04pantheon.jpg)
