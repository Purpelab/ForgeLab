# OSSIEM - Open Source SIEM Stack

Le projet **OSSIEM** (Open Source SIEM Stack) est une solution open source permettant de déployer et tester une stack de sécurité basée sur des outils comme **Wazuh**, **Graylog**, et **Velociraptor**. Cette solution est conçue pour tester l'intégration de **SOCFortress** dans un environnement de laboratoire.

> [Lien vers l'outil OSSIEM](https://github.com/socfortress/OSSIEM)


# Chaîne de Traitement des Logs 
Cette section présente la chaîne de traitement des logs dans notre infrastructure de sécurité, en détaillant les outils utilisés à chaque étape et leurs interactions.

### 1. Sources de Logs
- **Équipements** : Serveurs, Applications, Containers, Endpoints
- **Rôle** : Ces équipements génèrent des logs contenant des informations essentielles sur les activités système, réseau et les événements de sécurité. Les logs sont envoyés aux outils suivants pour traitement.

### 2. Fluent Bit
- **Rôle** : Collecte et transmet les logs provenant des différentes sources.
- **Fonctionnement** : **Fluent Bit** est l'outil initial qui collecte, filtre, transforme et enrichit les logs avant de les transmettre à des systèmes comme **Graylog** ou **Elasticsearch**. Il joue un rôle clé en structurant les logs (par exemple, en les convertissant en JSON) pour faciliter leur indexation et leur analyse ultérieure.

### 3. Wazuh Agent
- **Rôle** : Collecte des logs de sécurité spécifiques sur les hôtes.
- **Fonctionnement** : Une fois que **Fluent Bit** a transmis les logs à l'environnement, **Wazuh Agent** prend en charge la collecte des événements liés à la sécurité (par exemple, des alertes ou des événements système). Il surveille les endpoints et envoie ces informations au **Wazuh Manager** pour une analyse détaillée.

### 4. Wazuh Manager
- **Rôle** : Analyse, corrèle et détecte des menaces à partir des logs collectés.
- **Fonctionnement** : **Wazuh Manager** reçoit les logs des **Wazuh Agents** (et de d'autres sources, comme Fluent Bit) et effectue une analyse en profondeur. Il détecte les menaces, corrèle les événements et génère des alertes basées sur des règles définies. Ces alertes peuvent ensuite être envoyées à des outils comme **Graylog** pour une gestion centralisée.

### 5. Graylog
- **Rôle** : Centralisation, gestion et analyse des logs.
- **Fonctionnement** : **Graylog** joue un rôle central dans l'architecture. Après avoir reçu les logs de **Wazuh Manager** (et potentiellement de **Fluent Bit**), il indexe ces logs, fournit une analyse en temps réel et génère des alertes sur les événements de sécurité détectés. Grâce à ses capacités de recherche et de visualisation, il offre aux analystes un accès rapide aux données pour effectuer des investigations approfondies.

### 6. Velociraptor
- **Rôle** : Collecte granulaire de données et gestion des endpoints.
- **Fonctionnement** : Lorsque des investigations plus approfondies sont nécessaires, **Velociraptor** permet de collecter des données détaillées sur les endpoints. Il fournit des informations granulaire sur des machines, comme les processus en cours, l'historique des fichiers, ou d'autres artefacts système. Il permet d'effectuer des recherches à distance et de gérer les endpoints dans un environnement de sécurité, particulièrement utile lors de réponses à incidents.

### 7. Copilot
- **Rôle** : Gestion et configuration des outils dans un environnement SIEM.
- **Fonctionnement** : **Copilot** facilite la gestion et la configuration des outils au sein de l'infrastructure. Lorsqu'il est démarré, **Copilot** permet une administration simplifiée des outils comme **Velociraptor**, **Wazuh**, et **Graylog**, garantissant ainsi une orchestration fluide et une gestion efficace des configurations au sein de l'infrastructure SIEM.

---

Cette chaîne de traitement chronologique assure une collecte, une analyse et une gestion des logs en temps réel, permettant une détection rapide des menaces et des réponses appropriées aux incidents de sécurité.
