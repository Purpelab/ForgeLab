# Choix de la solution : Dashy vs Homarr

Le but du dashboard est d'afficher quelques info sur le système, centralisés les liens vers les services du serveur ainsi que de stocker et se partager des liens vers des ressources et outils !
# 🌐 Homarr

[Homarr](https://homarr.dev/) est un tableau de bord simple et puissant pour gérer votre serveur. Il offre des intégrations pour divers services, facilitant la gestion des applications et des données à partir d'une interface centralisée.

## 🐳 Installer Homarr avec Docker Compose

```bash
# Créez le fichier docker-compose.yml
echo "version: '3'
services:
  homarr:
    container_name: homarr
    image: ghcr.io/ajnart/homarr\:latest
    restart: unless-stopped
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ./homarr/configs:/app/data/configs
      - ./homarr/icons:/app/public/icons
      - ./homarr/data:/data
    ports:
      - '7575:7575'" > docker-compose.yml

# Lancer Homarr
docker-compose up -d

# Mise à jour
docker-compose down
docker-compose pull
docker-compose up -d

# Désinstallation
docker-compose down
docker image prune
```

# 🌐 Dashy

[Dashy](https://dashy.to/) est un tableau de bord simple, puissant et hautement configurable. Il offre des intégrations pour divers services, facilitant la gestion des applications et des données à partir d'une interface centralisée.

## 🐳 Installer Dashy avec Docker Compose

```bash
# Créez le fichier docker-compose.yml
echo "version: '3'
services:
  dashy:
    container_name: dashy
    image: lissy93/dashy\:latest
    restart: unless-stopped
    volumes:
      - ./dashy/config:/app/public
    ports:
      - '80:80'" > docker-compose.yml

# Lancer Dashy
docker-compose up -d

# Mise à jour
docker-compose down
docker-compose pull
docker-compose up -d

# Désinstallation
docker-compose down
docker image prune
```

# 🔍 Dashy vs Homarr
Après avoir testé Dashy et Homarr, notre choix s’est porté sur Dashy.
Bien que **Dashy soit plus complexe à configurer**, il se distingue par sa **personnalisation**. Il permet d’adapter chaque détail, de la mise en page aux couleurs et icônes, offrant un dashboard sur mesure. 
De plus, nous trouvons que Dashy est plus stable. 

À l’inverse, Homarr est **plus simple à configurer** et **rapide à prendre en main**, mais ses options limitées peuvent devenir contraignantes à long terme. 

> En résumé, Dashy offre une solution robuste, durable et hautement personnalisable mais un peu plus complexe à configurer.

