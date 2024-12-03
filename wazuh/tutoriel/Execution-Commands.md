
#  🛡️Intercepter Certaines Commandes 🛡️


Ce guide explique les étapes nécessaires pour déployer une règle personnalisée dans Wazuh, afin de surveiller l'exécution de commandes spécifiques telles que `id`, `whoami`, etc.


---


## **Pré-requis ✅**


Avant de commencer, assurez-vous que :
- Wazuh est correctement installé et configuré. 🖥️
- Vous avez accès à l'interface Wazuh Manager. 🔒
- Les permissions d'écriture sur les fichiers de configuration Wazuh sont disponibles. ✍️
- Prendre connaissance de cela : 

### CDB Lists 📝

Les listes **CDB** dans Wazuh sont utilisées pour détecter des menaces, telles que des malwares 🦠, en comparant des valeurs extraites (hashs de fichiers, adresses IP) à des entrées dans des listes pré-définies. Elles permettent de générer des **alertes** 🚨 lorsque des correspondances sont trouvées, renforçant ainsi la détection des menaces.

```bash
/var/ossec/etc/lists/
```

- [network](https://github.com/CupOfCoffeeX/ForgeLab/blob/main/wazuh/CustomRules/CDB%20Lists/network) 🌐 /var/ossec/etc/lists/network - liste de commandes pour énumérer le réseau
- [tools](https://github.com/CupOfCoffeeX/ForgeLab/blob/main/wazuh/CustomRules/CDB%20Lists/tools)🛠️ /var/ossec/etc/lists/network -  liste de commandes en liens avec des outils malveillants 
- [user-enum](https://github.com/CupOfCoffeeX/ForgeLab/blob/main/wazuh/CustomRules/CDB%20Lists/user-enum) 👤 /var/ossec/etc/lists/network - liste de commandes pour énumérer les users
---



## **Étape 1 : Installation d'auditd 🛠️**



1. Installation et activation d'auditd : 
   
   ```bash
   sudo apt -y install auditd
   sudo systemctl start auditd
   sudo systemctl enable auditd
   ```


2. En tant que root exécuter les commandes suivantes pour ajouter les règles auditd à `/etc/audit/audit.rules` : 
   
   ```bash
   echo "-a exit,always -F auid=1000 -F egid!=994 -F auid!=-1 -F arch=b32 -S execve -k audit-wazuh-c" >> /etc/audit/audit.rules
   echo "-a exit,always -F auid=1000 -F egid!=994 -F auid!=-1 -F arch=b64 -S execve -k audit-wazuh-c" >> /etc/audit/audit.rules
   ```


3. Rechargement et vérification des règles : 
   
   ```bash
   sudo auditctl -R /etc/audit/audit.rules
   sudo auditctl -l
   ```


4. Lier les logs auditd à Wazuh : 
   
   ```xml
<localfile>
  <log_format>audit</log_format>
  <location>/var/log/audit/audit.log</location>
</localfile>
   ```



## **Étape 2 : Créer une Règle Personnalisée 📝**



1. Créer une liste CDB `/var/ossec/etc/lists/suspicious-programs` : 
   
   ```
   ncat:yellow
   nc:red
   tcpdump:orange
   ```

   
2. Ajouter la liste à la section `<ruleset>` dans `/var/ossec/etc/ossec.conf` : 
   
   ```xml
   <list>etc/lists/suspicious-programs</list>
   ```


3. Créez un nouveau fichier de règles (par exemple, `/var/ossec/etc/rules/local_rules.xml`) :


```xml
<group name="audit">
  <rule id="100210" level="12">
      <if_sid>80792</if_sid>
  <list field="audit.command" lookup="match_key_value" check_value="red">etc/lists/suspicious-programs</list>
    <description>Audit: Highly Suspicious Command executed: $(audit.exe)</description>
      <group>audit_command,</group>
  </rule>
</group>
```



## **Étape 3 : Redémarrer le Service Wazuh Manager 🔄**



```bash
sudo systemctl restart wazuh-manager
```


