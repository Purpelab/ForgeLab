# Présentation de l'outil 

CrowdSec est une solution open-source de détection et de réponse aux menaces, conçue pour protéger les infrastructures contre les attaques. Elle analyse les logs en temps réel, identifie les comportements suspects et prend des mesures automatiques pour bloquer les attaquants. CrowdSec utilise des scénarios prédéfinis et des bouncers pour appliquer des décisions de sécurité, offrant une protection proactive et collaborative grâce à une communauté partageant des informations sur les menaces.

![crowdsec](/assets/crowdsec.png)

## Collection

📦 Un ensemble de configurations de scénarios.

- **Grafana** : Pas pertinent, car pas exposé et à jour (détecte le bruteforce et les CVE).
- **Iptables** : Détection de scan de ports, mais inutile car seul le port 443 est exposé.
- **Linux-lpe** : Va générer beaucoup de faux positifs.
- **Vaultwarden** : Installé et en attente de Vaultwarden.
- **Bookstack** : Détecte les échecs de connexion à Bookstack. - Pour plus tard
- **PfSense** : La collection CrowdSec pour pfSense détecte les attaques sur le pare-feu, y compris le bruteforce SSH, le bruteforce sur l'interface web et les scans de ports.

 ## Scénarios

🔍 Un scénario définit la manière de détecter une menace, basé sur des logs ou des événements spécifiques (par exemple : attaque par brute force SSH).

- **Fichier associé** : `/etc/crowdsec/scenarios/`
- **Commande pour lister les scénarios actifs** :
  ```bash
  sudo cscli scenarios list
  
## Décisions
📋 Commande pour voir les décisions :
  ```bash
sudo cscli decisions list
  ```
Utilité : Les décisions sont des actions qui sont appliquées suite à un scénario d’attaque (par exemple, bannir une IP pendant 1 heure).

## Bouncers
🛡️ Un bouncer est un composant qui applique les décisions de CrowdSec (par exemple, bloquer une IP dans un pare-feu, ou sur un proxy). Les bouncers sont responsables de la mise en œuvre des décisions (comme les IP bans) dans l'infrastructure de sécurité.

- Exemples de bouncers : `crowdsec-firewall-bouncer`
- Fichier associé : `/etc/crowdsec/bouncers/` (configuration des bouncers)
Commande pour voir les bouncers actifs :
```bash
sudo cscli bouncers list
```
Utilité : Permet de connecter CrowdSec aux outils de sécurité (iptables, Nginx, etc.) pour appliquer les décisions automatiquement.

> Créer un scénario + parser + ajouter le fichier de logs à récupérer dans acquis.yaml

---

## Commandes de Base

  ```bash

# Démarrer CrowdSec
sudo systemctl start crowdsec

# Arrêter CrowdSec
sudo systemctl stop crowdsec

# Redémarrer CrowdSec
sudo systemctl restart crowdsec

# Vérifier l'état de CrowdSec
sudo systemctl status crowdsec
  ```
## Commandes de Configuration
  ```bash

# Éditer le fichier de configuration principal
sudo nano /etc/crowdsec/config.yaml

# Éditer le fichier de configuration des bouncers
sudo nano /etc/crowdsec/bouncers/crowdsec-firewall-bouncer.yaml

# Éditer le fichier de configuration des scénarios
sudo nano /etc/crowdsec/scenarios/opencanary_bf.yaml

# Éditer le fichier de configuration des parsers
sudo nano /etc/crowdsec/parsers/s01-parse/opencanary.yaml

# Augmenter durée de banissement
sudo nano /etc/crowdsec/profile.yaml
  ```
## Gestion d'Erreur et Tests
  ```bash

# Consulter les logs de CrowdSec
sudo journalctl -u crowdsec

# Expliquer les logs simulés
sudo cscli explain --file /var/tmp/opencanary.log --type opencanary

# Lister les décisions prises par CrowdSec
sudo cscli decisions list
  ```

---

## Opencanary <--> CrowdSec

Le but est que CrowdSec utilise les logs de Opencanary et bloque les IPs qui se sont fait avoir par le honeypot.

### Scénario (`/etc/crowdsec/scenarios/opencanary_bf.yaml`)

```yaml
type: trigger
name: crowdsecurity/opencanary_bf
description: "Detect and block IPs from OpenCanary logs"
filter: evt.Meta.log_type == 'opencanary_event'
groupby: evt.Meta.source_ip
labels:
  service: opencanary
  type: bruteforce
  remediation: true
```

### Parser (/etc/crowdsec/parsers/s01-parse/opencanary.yaml)
```yaml
name: crowdsecurity/opencanary-logs
description: "Parse OpenCanary logs"
filter: "evt.Parsed.program == 'opencanary' && UnmarshalJSON(evt.Parsed.message, evt.Unmarshaled, 'opencanary') in ['', nil]"
onsuccess: next_stage
statics:
  - meta: service
    value: opencanary
  - meta: source_ip
    expression: evt.Unmarshaled.opencanary.src_host
  - meta: log_type
    value: opencanary_event
  - target: evt.StrTime
    expression: evt.Unmarshaled.opencanary.utc_time
  - meta: src_host
    expression: evt.Unmarshaled.opencanary.src_host
```
### Donner le chemin des logs (/etc/crowdsec/acquis.yaml)
```yaml
filenames:
  - /var/tmp/opencanary.log
labels:
  type: opencanary

```
# Demo Web
On a bien accès au site : 

![demo1](/assets/demo1.png)

Je lance Nikto : 

![demo2](/assets/demo2.png)

> Il s'arrête d'un coup !

**Je n'ai plus accès au site et l'IP est bannie pendant 8 h !**

![demo3](/assets/demo3.png)


## Amélioration : Utilisation du bouncer Nginx

J'avais initialement prévu d'implémenter un bouncer Nginx spécifiquement pour mon serveur web, en complément du bouncer firewall, afin de mieux protéger mon serveur des attaques HTTP comme les tentatives de brute force, les scans de vulnérabilités ou les injections. Le bouncer Nginx permettrait de filtrer les requêtes malveillantes avant qu'elles n'atteignent le serveur, réduisant ainsi la charge et améliorant les performances. Le bouncer firewall, quant à lui, offre une protection générale pour le réseau, en filtrant les connexions indésirables au niveau du pare-feu. Cette approche aurait permis une défense supplémentaire et plus ciblée pour mon serveur web.
Cependant, pour installer ce bouncer, il était nécessaire de revenir à la version 1.24 de Nginx, tandis que je suis actuellement sur la version 1.26.2. Après réflexion, j'ai décidé de ne pas rétrograder la version de Nginx. Bien que Nginx 1.24 soit stable, cette version pourrait comporter des vulnérabilités plus anciennes et moins d'améliorations par rapport à la version 1.26.2, qui bénéficie de mises à jour de sécurité et de correctifs récents.


## Dashboard avec Metabase

Metabase est un outil open-source de business intelligence (BI) qui permet de créer facilement des tableaux de bord interactifs, des rapports et des analyses de données.

```bash
# Installer le dashboard sur le port 3001 avec une adresse d'écoute sur 0.0.0.0
sudo cscli dashboard setup -l 0.0.0.0 -p 3001

# Installer le dashboard sur le port 3001 avec un mot de passe spécifié
sudo cscli dashboard setup -p 3001 --password <votre_mot_de_passe>

# Installer le dashboard en écrasant une installation existante
sudo cscli dashboard setup -p 3001 -f

# Démarrer le dashboard
sudo cscli dashboard start

# Arrêter le dashboard
sudo cscli dashboard stop

# Supprimer le dashboard
sudo cscli dashboard remove
```

![metabase1](/assets/metabase1.png)

![metabase1](/assets/metabase2.png)

# Retour sur l'outil

CrowdSec est vraiment complet et facile à utiliser, à intégrer et à déployer. Le seul bémol serait qu'il peut être compliqué à gérer et à mettre en place pour de grandes infrastructures. Cependant, l'un de ses avantages majeurs est qu'il est gratuit, ce qui en fait une solution très attrayante. Il faut bien le configurer pour en tirer le meilleur parti.

> Petite parenthèse ...

Fail2Ban est un outil de sécurité qui surveille les fichiers journaux pour détecter les tentatives d'accès malveillantes et bloque les IPs suspectes en les ajoutant à un pare-feu (iptables).
```
sudo apt update
sudo apt install fail2ban
sudo systemctl status fail2ban
```

**Configurer Fail2Ban :**

```
Si vous souhaitez personnaliser la configuration, créez un fichier jail.local pour ne pas écraser les paramètres par défaut de jail.conf :
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
sudo systemctl restart fail2ban
sudo fail2ban-client status
```

