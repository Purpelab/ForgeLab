# Détection sur le user administrateur1 (leurre)

Le but est de détecter **les accès au répertoire `/home/administrateur1`** ou **les tentatives de connexion avec l'utilisateur `administrateur1`**, pour ce faire nous allons utiliser une combinaison de techniques avec `auditd`, la gestion des journaux système (`pam`, `auth.log`), et Wazuh.

---

## **Étape 1 : Créer l'utilisateur `administrateur1` **

1. **Créer un utilisateur système sans connexion interactive :**

    ```bash
    sudo useradd -M -r -s /usr/sbin/nologin administrateur1
    ```

    - **`-M`** : Ne crée pas de répertoire personnel.
    - **`-r`** : Crée un utilisateur système pour leurrer l'attaquant.
    - **`-s /usr/sbin/nologin`** : Empêche toute connexion interactive directe.

2. **Créer manuellement un répertoire personnel (si besoin pour attirer l'attaquant) :**

    ```bash
    sudo mkdir /home/administrateur1
    sudo chown administrateur1:administrateur1 /home/administrateur1
    sudo chmod 711 /home/administrateur1
    ```

    - **Explication des permissions `chmod 711` :**
Les permissions chmod 711 permettent au propriétaire un accès complet, tandis que les autres peuvent seulement exécuter et voir le répertoire sans lister son contenu, attirant ainsi les attaquants.

---

## Étape 2 : Configurer `auditd` pour surveiller le répertoire

1. **Ajouter une règle pour surveiller les accès au répertoire :**

    Utilisez la commande suivante pour ajouter une règle temporaire avec `auditd` :

    ```bash
    sudo auditctl -w /home/administrateur1 -p rwxa -k admin_leurre_access
    ```

    - **`-w`** : Surveille le répertoire spécifié (`/home/administrateur1`).
    - **`-p rwxa`** :
        - **`r`** : Lecture.
        - **`w`** : Écriture.
        - **`x`** : Exécution (tentatives d'accès).
        - **`a`** : Changements d'attributs (permissions, propriétés).
    - **`-k admin_leurre_access`** : Définit une clé unique pour identifier facilement ces événements dans les journaux.

2. **Rendre cette règle permanente :**

    Ajoutez la règle dans le fichier de configuration d'`auditd` pour qu'elle persiste après un redémarrage :

    ```bash
    echo "-w /home/administrateur1 -p rwxa -k admin_leurre_access" | sudo tee -a /etc/audit/rules.d/audit.rules
    ```

3. **Tester la règle :**

    - Accédez au répertoire (en tant qu'utilisateur ou superutilisateur) :

        ```bash
        cd /home/administrateur1
        ```

    - Vérifiez les journaux d’audit pour voir si l'accès a été enregistré :

        ```bash
        sudo ausearch -k admin_leurre_access | aureport -f
        ```

        Vous devriez voir une entrée correspondant à votre tentative d'accès.

---

## **Étape 3 : Surveiller les tentatives de connexion avec `auditd`**

1. **Ajouter une règle pour enregistrer les tentatives de connexion à l’utilisateur `administrateur1` :**

    ```bash
    sudo auditctl -a always,exit -F arch=b64 -S execve -F uid=995 -F key=login_admin_leurre
    ```

    - **`-a always,exit`** : Capture toutes les exécutions de commandes.
    - **`-F uid=995`** : Remplacez `1001` par l’UID réel de l’utilisateur `administrateur1`. Vous pouvez obtenir l’UID avec :

        ```bash
        id -u administrateur1
        ```

    - **`-F key=login_admin_leurre`** : Utilise une clé pour identifier facilement ces événements.

2. **Rendre cette règle permanente :**

    Ajoutez-la à `/etc/audit/rules.d/audit.rules` :

    ```bash
    echo "-a always,exit -F arch=b64 -S execve -F uid=\$(id -u administrateur1) -F key=login_admin_leurre" | sudo tee -a /etc/audit/rules.d/audit.rules
    ```

3. **Redémarrez auditd pour appliquer les règles :**

    ```bash
    sudo systemctl restart auditd
    ```

4. **Tester la règle :**

    Essayez de vous connecter en tant que `administrateur1` ou de lancer une commande en tant que cet utilisateur. Vérifiez les journaux d’audit avec :

    ```bash
    sudo ausearch -k login_admin_leurre | aureport -x
    ```

---

## **Étape 4 : Intégrer avec Wazuh**

1. **Ajouter une règle Wazuh pour surveiller les accès au répertoire et les tentatives de connexion :**

    Éditez ou créez le fichier de règles locales `/var/ossec/rules/local_rules.xml` :

    ```bash
    sudo nano /var/ossec/rules/local_rules.xml
    ```

    Ajoutez les règles suivantes :

    ```xml
    <group name="custom_rules">
        <!-- Détection des accès au répertoire -->
        <rule id="100002" level="10">
            <decoded_as>audit</decoded_as>
            <description>Access detected to /home/administrateur1</description>
            <match>admin_leurre_access</match>
        </rule>
        <!-- Détection des tentatives de connexion -->
        <rule id="100003" level="10">
            <decoded_as>audit</decoded_as>
            <description>Login attempt detected for administrateur1</description>
            <match>login_admin_leurre</match>
        </rule>
    </group>
    ```

    - **`id`** : Assurez-vous que ces IDs (100002 et 100003) sont uniques parmi vos règles.
    - **`level="10"`** : Criticité élevée pour générer une alerte importante.

2. **Redémarrer le gestionnaire Wazuh :**

    ```bash
    sudo systemctl restart wazuh-manager
    ```

3. **Tester la configuration :**

    - Accédez au répertoire `/home/administrateur1` ou tentez de vous connecter avec l’utilisateur `administrateur1`.
    - Vérifiez que les alertes apparaissent dans les logs Wazuh : `/var/ossec/logs/alerts/alerts.json`.

---


### Résultat attendu

1. **Détection des accès au répertoire `/home/administrateur1` :**

    - Toute tentative d’accès sera enregistrée par `auditd` et générera une alerte dans Wazuh.

2. **Détection des tentatives de connexion à `administrateur1` :**

    - Toute tentative d’exécuter des commandes ou de se connecter sera détectée.

3. **Alertes visibles via Wazuh :**

    - Vous pourrez surveiller ces événements en temps réel et recevoir des notifications.
