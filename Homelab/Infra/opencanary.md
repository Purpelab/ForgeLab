# OpenCanary

OpenCanary est un honeypot léger et flexible que j'utilise pour simuler des services et attirer les attaquants. Cela me permet de détecter les attaques potentielles et analyser les méthodes des attaquants, tout en protégeant mes systèmes réels en les attirant dans un environnement contrôlé.

## Étapes d'Installation et de Configuration

1. **Installer OpenCanary dans un environnement virtuel**

   ```bash
   # Mettez à jour votre système et installez les dépendances
   sudo apt update
   sudo apt install python3-venv python3-dev libssl-dev libffi-dev -y

   # Créez un environnement virtuel
   python3 -m venv ~/opencanary-venv

   # Activez l'environnement virtuel
   source ~/opencanary-venv/bin/activate

   # Installez OpenCanary
   pip install opencanary
   ```

> Note : Une fois l'environnement virtuel activé, vous pouvez installer et utiliser OpenCanary dans un environnement isolé, ce qui est recommandé pour éviter les conflits avec d'autres packages système.

2. **Configurer OpenCanary**

Générez un fichier de configuration par défaut pour OpenCanary `(dans le répertoire courant : /etc/opencanaryd/opencanary.conf)`. 

```bash
# Créez un fichier de configuration par défaut
~/opencanary-venv/bin/opencanaryd --copyconfig
```
3. **Modifier la configuration**
> Mon serveur web tourne sur le port 443 pour le HTTPS, et mon SSH est configuré sur le port 2222 pour des raisons de sécurité, car ce n'est pas le port par défaut. 

> J'ai activé le port 80 pour simuler un service HTTP et 22 pour simuler SSH, car se sont les ports par défaut et donc il sont ciblé le plus souvent. 

4. Ouvrir les ports sur ufw
```
# Autorisez le port SSH (22)
sudo ufw allow 22/tcp

# Autorisez le port HTTP (8080)
sudo ufw allow 80/tcp
```
5. **Lancer OpenCanary**
```
# Lancez OpenCanary avec la configuration modifiée
~/opencanary-venv/bin/opencanaryd --start --uid=nobody --gid=nogroup
```

**Désactiver l'environnement virtuel**
 ```  
deactivate
```

**Modifier la configuration**
```
sudo nano /etc/opencanaryd/opencanary.conf
```
6. **Redémarrer le service**
```
/home/alex/opencanary-venv/bin/opencanaryd --restart --uid=nobody --gid=nogroup
```
7. Voir les logs
```
cat /var/tmp/opencanary.log | jq
```
---
## Pour plus de sécurité j'ai fait un docker 

### [Installer Docker](https://docs.docker.com/engine/install/ubuntu/)

### [Configurer Opencanary sur Docker](https://github.com/thinkst/opencanary/wiki/Using-Dockerised-OpenCanary#building-and-running-your-own-docker-opencanary-image-with-docker-compose)
