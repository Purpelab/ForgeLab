# Honeypot


## 1 - Honeypot pour surveiller l'accès à `/home/alex/credentials-admin.txt`

## Introduction

L'objectif de ce tutoriel est de créer un honeypot en utilisant un fichier `/home/alex/credentials-admin.txt` qui contient des informations sensibles. Ce fichier servira de leurre, et nous allons surveiller tout accès ou tentative d'accès à ce fichier pour détecter d'éventuelles attaques. Nous utiliserons `auditd` pour suivre les actions sur le fichier et Wazuh pour générer des alertes en cas de comportement suspect.

### Pré-requis

Avant de commencer, voici les éléments à préparer :

- Un utilisateur `administrateur1` qui aura aucun droit d'accès sur le fichier cible.
- Un répertoire `/home/administrateur1` qui sera créé avec des permissions minimales pour attirer un attaquant potentiel.
- Un fichier honeypot `/home/alex/credentials-admin.txt` qui contiendra des informations sensibles que nous allons surveiller.


1. **Création du fichier honeypot `/home/alex/credentials-admin.txt` :**

    Ce fichier servira de cible pour surveiller l'accès.

    ```sh
    sudo nano /home/alex/credentials-admin.txt
    sudo chmod 600 /home/alex/credentials-admin.txt  # Réduit les permissions
    ```

---

## Configuration des règles Auditd

### 1. Introduction aux règles Auditd

Les règles `auditd` permettent de surveiller les actions sur des fichiers ou répertoires spécifiques, y compris les accès en lecture, écriture ou exécution. L'outil `auditd` (audit daemon) peut être utilisé pour configurer des règles permettant de suivre les actions d'accès à des fichiers sensibles.

#### Comprendre les arguments importants

- `-w` : Cette option permet de spécifier le fichier ou le répertoire à surveiller.
- `-p` : Définit les permissions à surveiller. Les options disponibles sont :
    - `r` : lecture
    - `w` : écriture
    - `x` : exécution
    - `a` : ajout de données (ajout d'un fichier par exemple)
- `-k` : Définit une clé pour associer les règles, facilitant la recherche dans les logs.

### 2. Commandes pour ajouter les règles Auditd

```sh
sudo nano /etc/audit/rules.d/audit.rules

```
Ajouter les lignes suivantes pour monitorer le fichier `credentials-admin.txt`:

```sh

-w /home/alex/credentials-admin.txt -p w -k audit-wazuh-w
-w /home/alex/credentials-admin.txt -p r -k audit-wazuh-r
-w /home/alex/credentials-admin.txt -p x -k audit-wazuh-x
-w /home/alex/credentials-admin.txt -p a -k audit-wazuh-a
```

3. Appliquer les règles
Après avoir ajouté les règles au fichier de configuration audit.rules, vous devez les appliquer et vérifier que les règles sont actives :

```sh
sudo auditctl -R /etc/audit/rules.d/audit.rules
sudo auditctl -l  # Vérifie que les règles ont bien été appliquées
```

## Créer des règles de détection dans Wazuh

Wazuh possède déjà des règles pour surveiller les actions sur des fichiers sensibles :

- **ID 80784** : Détecte la **lecture** d'un fichier.
- **ID 80789** : Détecte l'**exécution** d'un fichier.
- **ID 80781** : Détecte la **modification** d'un fichier.

Nous allons nous appuyer sur ces règles existantes pour configurer des alertes lorsque des actions sont effectuées sur le fichier honeypot `/home/alex/credentials-admin.txt`.

> [Voir les règles crées](https://github.com/Purpelab/ForgeLab/rules/honeypot.xml)
> 
## Différence avec les règles FIM

| **Critère**                | **Règles Wazuh (Auditd)**                                 | **Règles FIM**                                     |
|----------------------------|-----------------------------------------------------------|----------------------------------------------------|
| **Objectif**               | Surveiller des actions (lecture, écriture, exécution) sur des fichiers spécifiques | Surveiller l'intégrité des fichiers (ajouts, suppressions, modifications) |
| **Exemples d'actions surveillées** | Lecture, Exécution, Modification                        | Ajout, Suppression, Modification du contenu        |



## Montorer la connection a l'utilisateur administrateur1

- Monitorer les logs de connexions avec auditd : 
```sh
-w /var/log/auth.log -p wa -k user-login
```

```sh
  <rule id="100304" level="15">
  <if_sid>80700</if_sid>
    <description>🍯 Le user administrateur1 a tenter de se connecter 🍯</description>
    <match>administrateur1</match>
        <info>
        Cette règle détecte une connexion au compte administrateur1 `/home/alex`.
    </info>
        <mitre>
        <id>T1071</id>
    </mitre>
    <group>,auditd,authentication_failed,honeypot,critical,</group>
  </rule>
```

Cette règle détecte quand administrateur1 est vue dans les logs de connexion. (ex : su administrateur1)
