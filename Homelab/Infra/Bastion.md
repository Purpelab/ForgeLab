# Configuration d'un Bastion avec Teleport

Un bastion (ou bastion host) sert de point d'entrée sécurisé pour accéder à des ressources internes ou protégées, généralement dans un réseau privé. Il agit comme une porte d'entrée contrôlée et sécurisée, permettant aux utilisateurs autorisés de se connecter à d'autres serveurs ou services en interne, souvent via des protocoles comme SSH ou RDP.

## Choix entre Guacamole et Teleport

J'ai hésité entre Guacamole et Teleport car ces deux solutions sont conçues pour l'accès à distance, mais dans des contextes différents. Guacamole est plus adapté à l'accès aux sessions distantes via des interfaces graphiques, tandis que Teleport est conçu pour sécuriser et centraliser l'accès aux systèmes à travers des outils de contrôle avancés et des audits.

Finalement, j'ai opté pour Teleport car il répondait mieux à mes besoins. Il permet à mes utilisateurs de se connecter de manière sécurisée (via SSH, RDP, etc.), tout en offrant aux administrateurs un contrôle sur qui a accès à quoi et quand. De plus, il offre une gestion des accès temporaires et un suivi des actions via des journaux d'audit.

## Installer Teleport

### Étapes :

1. **Définissez les variables nécessaires pour la version et l’édition de Teleport :**

    ```bash
    export TELEPORT_EDITION="oss"  # Pour la version gratuite de Teleport (Community Edition)
    export TELEPORT_VERSION="16.4.12"  # Version actuelle recommandée
    ```

2. **Téléchargez et exécutez le script d’installation :**

    ```bash
    curl https://cdn.teleport.dev/install-v\${TELEPORT_VERSION}.sh | bash -s ${TELEPORT_VERSION} ${TELEPORT_EDITION}
    ```

3. **Vérifiez l’installation :**

    ```bash
    teleport version
    ```

## Configurer Teleport

### Modifier le fichier de configuration `/etc/teleport.yaml`

Ouvrez le fichier de configuration avec un éditeur de texte comme nano :

```bash
sudo nano /etc/teleport.yaml
```

Exemple de configuration pour votre serveur (Je n'ai qu'un certificat auto signé) :

```yml
version: v3
teleport:
  nodename: Bastion
  data_dir: /var/lib/teleport
  log:
    output: stderr
    severity: INFO
    format:
      output: text
  ca_pin: ""
  diag_addr: ""
auth_service:
  enabled: "yes"
  listen_addr: 0.0.0.0:3025
  cluster_name: bastion-tp.chickenkiller.com
  proxy_listener_mode: multiplex
ssh_service:
  enabled: "yes"
proxy_service:
  enabled: "yes"
  web_listen_addr: 0.0.0.0:443
  public_addr: bastion-tp.chickenkiller.com:443
  acme:
    enabled: "no"
```

Il est possible d'en géner un : 

```
sudo teleport configure -o file --acme --acme-email=XXX --cluster-name=XXX
sudo systemctl restart teleport
sudo systemctl status teleport
```

## Créer un compte administrateur

```
sudo tctl users add admin --roles=editor,access --logins=admin,root
```

Après avoir exécuté la commande, vous obtiendrez un message avec une URL pour terminer la configuration du compte.

![teleport1](/assets/teleport1.png)

---

## Enroller un machine sans certificats 

Utiliser le script fournis en ajoutant -k pour ignorer les certificats.
Dans  ```/usr/lib/systemd/system/teleport.service ajouter``` --insecure

![teleport2](/assets/teleport2.png)

Rédemarrer le deamon et le service : 
```
sudo systemctl restart teleport
sudo systemctl status teleport
```

## Supprimer agent : 

```
sudo systemctl stop teleport
sudo systemctl disable teleport

# Recharger les configurations systemd
sudo systemctl daemon-reload

# Désinstaller le logiciel de l'agent (exemple pour teleport)
sudo apt-get remove --purge teleport

# Supprimer les fichiers de configuration restants
sudo rm -rf /etc/teleport
sudo rm -rf /var/lib/teleport
sudo rm -rf /run/teleport

# Supprimer les binaires de l'agent
sudo rm /usr/local/bin/teleport

# Si un fichier de configuration spécifique est utilisé
sudo rm -f /etc/default/teleport

# Chercher toutes les occurrences de "teleport" dans le système
sudo find / -name "*teleport*"
```
