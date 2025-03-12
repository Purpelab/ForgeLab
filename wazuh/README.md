# Qu'est-ce que Wazuh ?

**Wazuh** est une solution de détection d'intrusion (IDS) et de gestion des événements de sécurité (SIEM) qui collecte, analyse et corrèle les logs pour identifier les menaces sur votre infrastructure.

## Fonctionnement de Wazuh

1. **Agents Wazuh** :
   - Installés sur les hôtes à surveiller (serveurs, postes de travail, équipements réseau).
   - Ils collectent les logs système, d'application et de sécurité, ainsi que d'autres événements (ex : tentatives de connexion, erreurs système).

2. **Wazuh Manager** :
   - Le **manager** centralise les logs envoyés par les agents.
   - Il analyse les données à l'aide de **règles de détection** pour identifier les menaces potentielles (ex : attaques par force brute, élévation de privilèges).
   - Il applique des **règles de corrélation** pour croiser les logs et identifier des comportements suspects.

3. **Indexer** :
   - L'**indexer** est responsable de stocker et organiser les logs de manière structurée.
   - Les logs sont indexés pour une recherche rapide et une corrélation efficace avec d'autres événements.

4. **Alertes et Réponses** :
   - Si une anomalie est détectée, le manager génère une **alerte**.
   - Wazuh peut également automatiser certaines actions (ex : bloquer une IP via un firewall en cas de force brute).

## Résumé du Flux de Fonctionnement
- **Collecte** : Les agents collectent les logs.
- **Analyse** : Le manager analyse les logs avec des règles de détection.
- **Indexation** : Les logs sont organisés dans un index pour une consultation rapide.
- **Alertes** : Les alertes sont générées en cas de menace détectée.

> Pour en savoir plus sur les spécificité de la stack déployé sur notre infra, nous vous invitons à lire la partie sur [SocFortress](https://github.com/Purpelab/ForgeLab/blob/main/Homelab/Infra/SocFortress.md)
