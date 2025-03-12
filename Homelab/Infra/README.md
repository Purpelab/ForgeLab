# Infrastructure

[infrastructure](infrastructure.png)


# Outils

## Solutions de Sécurité

- **[CrowdSec](crowdsec.md)** et **[Wazuh](wazuh.md)** sont utilisés pour surveiller les logs, détecter les menaces et protéger l'environnement. 
- **[SocFortress](SocFortress.md)** est utilisé pour gérer ces outils.
- **[OpenCanary](opencanary.md)** est déployé pour la **CTI (Cyber Threat Intelligence)**, afin de détecter et bloquer les tentatives d'intrusions en temps réel.
  
## Serveur Web

Un serveur web **[Nginx](Nginx%20&%20Proxy.md)** est exposé afin de tester des **WAF (Web Application Firewall)** et analyser les éventuelles vulnérabilités.

## Accès Sécurisé

Le **[Bastion](Bastion.md)** a été remplacé par un **VPN sécurisé** pour une gestion à distance plus sûre.

## Hardening du Serveur

Le serveur a été durci à l'aide de **[Lynis](Hardenning.md)**, un outil d'audit de sécurité qui applique les meilleures pratiques pour la sécurité des systèmes.

## Rapport avec PurpleOps

Nous utilisons **[PurpleOps](PurpleOps.md)** pour générer des rapports détaillés entre la Blue Team et la Red Team.

