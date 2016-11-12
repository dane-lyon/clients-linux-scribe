## Scripts pour Client Scribe (x)Ubuntu 14.04 & 16.04

Ce **script** permet d'intégrer des clients GNU/Linux dans un environnement Eole-Scribe 2.3, 2.4 ou 2.5.

Les clients supportés/testés avec les scripts sont les suivants :
- Ubuntu (Environnement Unity) 14.04 et 16.04
- Xubuntu (Environnement XFCE) 14.04 et 16.04
- Lubuntu (Environnement LXDE) 14.04 et 16.04
- Ubuntu Mate (Environnement Mate) 16.04
- Linux Mint (Environnement Cinammon ou Mate) 17.3 et 18

Avant de lancer ce script, assurez-vous d'avoir installé toutes vos applications, puis vous pouvez cloner vos postes
avec la solution libre [OSCAR](http://oscar.crdp-lyon.fr/wiki/)

- Télécharger le script le script d'intégration :
```bash
wget https://raw.githubusercontent.com/dane-lyon/clients-linux-scribe/master/ubuntu-et-variantes-integrdom.sh
```

- Se placer dans le répertoire courant puis lancer les commandes :
```bash
chmod +x ubuntu-et-variantes-integrdom.sh
sudo ./ubuntu-et-variantes-integrdom.sh
```

### **Remarques :**

#### Script de post-installation

Pour gagner du temps lors de la création du poste modèle, on pourra utiliser ensuite le script de post-installation qui installera le système avec toutes les applications souhaitées : https://raw.githubusercontent.com/dane-lyon/clients-linux-scribe/master/ubuntu-et-variantes-postinstall.sh

#### Partages

Si votre serveur Scribe est en version "2.4" ou "2.5", par défaut vous n'aurez pas les partages avec les clients linux (groupes, classes etc...), pour régler le problème, vous devez faire la manipulation suivante sur votre serveur :
https://dane.ac-lyon.fr/spip/Client-Linux-activer-les-partages

### Problèmes d'identifications possibles

Pour ne pas avoir de problème d'identification, vérifier que :

- l'utilisateur a déjà changé une fois son mot de passe depuis un poste windows

OU

- le changement de mot de passe n'est pas demandé (case décochée dans l'ead pour l'utilisateur)

### Client Shell

De plus, il est impératif que la case "client shell linux" soit cochée pour les utilisateurs dans l'EAD du scribe sinon l'authentification ne pourra avoir lieu.

#### Personnalisation des valeurs par défaut

Vous pouvez éditer les valeurs par défaut en début de script afin de les adapter à votre environnement.

#### Personnalisation des menus de l'environnement Unity

Pour personnaliser le menu d'Unity à tous les utilisateurs, chercher dans le script ces lignes :

```bash
echo "[com.canonical.indicator.session]
user-show-menu=false
[org.gnome.desktop.lockdown]
disable-user-switching=true
disable-lock-screen=true
[com.canonical.Unity.Launcher]
favorites=[ 'nautilus-home.desktop', 'firefox.desktop', 'libreoffice-startcenter.desktop', 'gnome-calculator.desktop', 'gedit.desktop', 'org.gnome.Screenshot.desktop' ]
" > /usr/share/glib-2.0/schemas/my-defaults.gschema.override
```

La ligne
`favorites=[ 'nautilus-home.desktop', 'firefox.desktop','libreoffice-startcenter.desktop','gcalctool.desktop','gedit.desktop','gnome-screenshot.desktop' ]`
est à adapter en fonction de vos besoins :

Pour connaitre le nom des raccourcis, faire dans un terminal : `ls /usr/share/applications/`

Pour voir à quelle application cela correspond, avec l'explorateur, il faut se déplacer dans `/usr/share/applications/`

Pour appliquer les modifications, il faut lancer la commande :

```bash
sudo glib-compile-schemas /usr/share/glib-2.0/schemas
```

À noter que chaque élève ou enseignant pourra personnaliser son menu par la suite puisque le profil est local. La personnalisation sera, en revanche, propre à chaque poste.

### TO DO :

- gestion des mises à jour centralisées des postes clients
