# Intégration de règles de FIM dans Wazuh

**File Integrity Monitoring** (FIM) surveille les fichiers systèmes pour détecter toute modification, suppression ou ajout non autorisé.

Syscheck est un module de Wazuh qui surveille l'intégrité des fichiers et des répertoires. Il détecte les modifications, ajouts, suppressions et changements de permissions des fichiers, permettant ainsi de garantir que les fichiers critiques ne sont pas altérés de manière non autorisée.

## Configurer le fichier `ossec.conf`

Ajoute les lignes suivantes dans le fichier `ossec.conf` pour surveiller des fichiers sensibles :

```xml
<directories report_changes="yes" realtime="yes">/etc/shadow</directories>
<directories report_changes="yes" realtime="yes">/etc/group</directories>
<directories report_changes="yes" realtime="yes">/etc/ssh/sshd_config</directories>
<directories report_changes="yes" realtime="yes">/etc/sudoers</directories>
<directories report_changes="yes" realtime="yes">/etc/crontab</directories>
<directories report_changes="yes" realtime="yes">/etc/cron.d</directories>
<directories report_changes="yes" realtime="yes">/tmp</directories> <!--Attention aux Faux positif-->
```

## Règles par défaut de FIM
Par défaut, Wazuh utilise les règles suivantes pour FIM :
- 550 : Modification de fichier
- 553 : Suppression de fichier
- 554 : Ajout de fichier
  
> Ces règles se trouvent dans 0015-ossec_rules.xml.

**Solution 1 :** Augmenter le level de ces règles.

**Solution 2 :** Créer ses propres règles

## Créer des règles personnalisées

Ces règles déclenche une alerte critique lorsque Syscheck détecte une modification dans un fichier surveillé : 

```xml
<!-- File Integrity Monitoring : Règles personnalisées -->

<rule id="100003" level="15">
    <if_sid>550</if_sid>
    <description>🔒 Le fichier $(file) a été modifié 🔒</description>
    <info>
            Cette règle détecte un ajout d'un fichier dans d'un repertoire sensible.
            **Champs intéressants à regarder :**
            - syscheck.path
            - Utilisateur 
            
            **Que faire en cas de cette alerte :**
            1. Vérifiez si la commande était légitime et autorisée.
            2. Si la commande n'était pas autorisée, identifiez l'utilisateur et le processus responsable.
     </info>
    <mitre>
        <id>T1565.001</id>
    </mitre>
    <group>syscheck_integrity_change,critical,</group>
</rule>

<rule id="100004" level="15">
    <if_sid>553</if_sid>
    <description>🔒 Le fichier $(file)) a été supprimé 🔒</description>
    <mitre>
        <id>T1070.004</id>
    </mitre>
    <group>syscheck_integrity_change,critical,</group>
</rule>

<rule id="100005" level="15">
    <if_sid>554</if_sid>
    <description>🔒 Le fichier $(file) a été ajouté 🔒</description>
    <mitre>
        <id>T1105</id>
    </mitre>
    <group>syscheck_integrity_change,critical,</group>
</rule>
```

## Points à améliorer
- Problème avec $(syscheck.path) : La variable ne fonctionne pas correctement. L'objectif est de la faire afficher le chemin complet du fichier modifié dans l'alerte.
  > Problème résolu : [Voir la syntaxe](https://documentation.wazuh.com/current/user-manual/capabilities/file-integrity/creating-custom-fim-rules.html) pour les $(syntaxe)
- Exclusion des faux positifs : Le répertoire **/tmp** génère des faux positifs. Solution : Utilise une whitelist pour exclure les fichiers sûrs.

## Conclusion
La configuration de FIM dans Wazuh permet de protéger les fichiers critiques en détectant les changements non autorisés. La personnalisation des règles améliore la pertinence des alertes tout en réduisant les faux positifs.
