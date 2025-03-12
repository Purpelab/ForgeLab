# NGINX

Nginx est un serveur web open-source, utilisé pour la gestion de requêtes HTTP, HTTPS et de contenu statique. Il fonctionne aussi comme reverse proxy, load balancer et serveur de messagerie.
Voici un exemple de fichier docker-compose.yml pour faire tourner Nginx avec des volumes pour la configuration et les logs. 
```yml
services:
  nginx:
    image: nginx:latest
    container_name: nginx_proxy
    restart: always
    ports:
      - "80:80"        # Expose le port HTTP
      - "443:443"      # Expose le port HTTPS
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro      # Volume pour le fichier de configuration Nginx
      - ./data/certificates:/etc/letsencrypt:ro   # Volume pour les certificats SSL (si utilisé avec Nginx Proxy Manager)
      - ./data/logs:/var/log/nginx:rw              # Volume pour les logs Nginx
      - ./data/html:/usr/share/nginx/html:ro       # Volume pour les fichiers statiques à servir (HTML, images, etc.)
    networks:
      - nginx_network

networks:
  nginx_network:
    driver: bridge

```

🔹 Un proxy est un serveur intermédiaire qui relaie les requêtes entre un client et un serveur, offrant sécurité et filtrage. 
🔹 Un reverse proxy, lui, se place devant plusieurs serveurs et redirige les requêtes des clients vers le serveur approprié, améliorant la performance, la sécurité et la gestion du trafic.

# Nginx Proxy Manager (NPM)

Nginx Proxy Manager (NPM) est une interface graphique qui simplifie l'utilisation de Nginx comme reverse proxy. Au lieu de configurer Nginx manuellement en ligne de commande, NPM permet de le faire facilement via une interface web.

#  Sous domaine gratuit

[![FreeDNS Badge](https://img.shields.io/badge/FreeDNS-Configure-D14836?style=flat&logo=freebsd)](https://freedns.afraid.org/zc.php?from=L3N1YmRvbWFpbi8=)



