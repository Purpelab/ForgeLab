# Lynis

J'utilise Lynis pour effectuer un audit de sécurité complet sur mon système Ubuntu. Il permet de détecter des vulnérabilités, des erreurs de configuration et des pratiques de sécurité faibles. Cela me permet de renforcer la sécurité de mon serveur en suivant des recommandations spécifiques pour améliorer sa protection.
```
# Mettre à jour les dépôts
sudo apt update

# Installer Lynis
sudo apt install lynis -y

# Lancer un audit de sécurité complet
sudo lynis audit system
```

Avant hardenning  

[hardenning1](/assets/hardenning1.png)

Après hardenning 

[hardenning2](/assets/hardenning2.png)


Voici un résumé des configurations de durcissement effectuées sur votre système pour renforcer sa sécurité :

🔹 **Renforcement SSH** : Le transfert TCP a été désactivé dans la configuration SSH afin de réduire les vecteurs d'attaque potentiels. Une bannière d'avertissement a été ajoutée à /etc/issue et /etc/issue.net pour dissuader les accès non autorisés en affichant un message humoristique mais clair.
🔹 **Analyse des fichiers système** : L'outil rkhunter a été installé pour détecter les rootkits, portes dérobées et modifications suspectes sur les fichiers critiques.
🔹 **Audit des activités système** : Le service auditd a été activé pour collecter et analyser les événements système, offrant ainsi une traçabilité complète des actions utilisateur.
🔹 **Hardening des compilateurs** : Les permissions d'accès à GCC et G++ ont été restreintes, limitant leur utilisation au seul utilisateur root pour éviter les abus.
🔹 **Optimisation de Docker** : Les configurations bridge-nf-call-iptables et bridge-nf-call-ip6tables ont été corrigées pour garantir une bonne isolation réseau entre les conteneurs.
🔹 **Permissions des fichiers critiques** : Une analyse approfondie des permissions des fichiers sensibles a été effectuée, avec des ajustements pour restreindre l'accès selon le principe du moindre privilège.

> A 71 le risque est acceptable, durcir trop ma machine va me bloquer plus qu'autre chose

# Hardenning Docker
