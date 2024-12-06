# Intégration de Slack pour les alertes

Ce tutoriel vous explique comment configurer Slack pour recevoir des alertes depuis Wazuh.

## Étape 1 : Créer une application Slack
1. Rendez-vous sur [Slack API Apps](https://api.slack.com/apps) et cliquez sur **"Create New App"**.  > **From scratch** 

2. Donnez un nom à votre application, puis choisissez le workspace Slack où elle sera utilisée.  

---

## Étape 2 : Ajouter un Webhook entrant
1. Dans votre application Slack, accédez à l'onglet **"Features"** et sélectionnez **"Incoming Webhooks"**.  
   ![Incoming Webhooks](/assets/wazuh-slack.png)

2. Activez les **Incoming Webhooks** en basculant le bouton sur "ON".

3. Cliquez sur **"Add New Webhook to Workspace"**, sélectionnez un canal Slack (dans notre cas alerts), puis cliquez sur **"Autoriser"**.  
4. Copiez l’URL du Webhook et la mettre dans **/var/ossec/etc/ossec.conf**
   
```
  <integration>
    <name>slack</name>
    <hook_url><SLACK_WEBHOOK_URL></hook_url> <!-- Replace with your Slack hook URL -->
    <level>10</level> <!-- Génère des alertes lorsque le niveau est superieur à 10 L -->
    <alert_format>json</alert_format>
  </integration>
```



5. Redemarrer le service :
```bash
sudo systemctl restart wazuh-manager
```

Et voila le travail ! 
![Résultat](/assets/resultat.png)


Pour modifier le template des alertes : /var/ossec/integrations/slack.py

---

# Amélioration des alertes 
- Warning jaune pour les alertes High
- Danger rouge pour les Critique
- Enlever le champs full-log
- Ajouter des champs importants
- Ajout d'émojis


  ```python

  level = alert['rule']['level']

    if level <= 9:
        color = 'good'
    elif level >= 10 and level <= 12:
        color = 'warning'
    else:
        color = 'danger'

      # Initialiser le message
    msg = {}
    msg['color'] = color  # Affecter la couleur du message
    msg['pretext'] = 'WAZIZOU LE FILOU'  # Texte affiché avant l'alerte
    msg['title'] = alert['rule']['description'] if 'description' in alert['rule'] else 'N/A'  # Description de la règle
    # msg['text'] = alert.get('full_log')  

    # Ajouter des champs supplémentaires au message
    msg['fields'] = []

    # 1. Ajouter les informations concernant l'agent, si présentes
    if 'agent' in alert:
        msg['fields'].append(
            {
                'title': '💻 Agent',  
                'value': '({0}) - {1}'.format(alert['agent']['id'], alert['agent']['name']),  
            }
        )

    # 2. Ajouter les informations concernant la règle, si présentes
    msg['fields'].append(
        {
            'title': '📜 Règle',  #
            'value': '{0} _(Niveau {1})_'.format(alert['rule']['id'], level),  
        }
    )

    # 3. Ajouter l'emplacement, si présent
    msg['fields'].append({'title': '📍 Emplacement', 'value': alert['location']})

    # 4. Ajouter les informations concernant la tactique (MITRE), si présentes
    if 'mitre' in alert['rule'] and 'tactic' in alert['rule']['mitre']:
        msg['fields'].append(
            {
                'title': '🛡️ Tactic (MITRE)',  # Emoji de tactique
                'value': ', '.join(alert['rule']['mitre']['tactic']),  
            }
        )

    # 5. Ajouter les informations des groupes, si présentes
    if 'groups' in alert['rule']:
        msg['fields'].append(
            {
                'title': '🌐 Groupes',  
                'value': ', '.join(alert['rule']['groups']),  
            }
        )

    # 6. Ajouter les arguments de la commande execve, si présents
    if 'data' in alert and 'audit' in alert['data'] and 'execve' in alert['data']['audit']:
        execve_args = []
        for i in range(5):  # Nous allons chercher jusqu'à 5 arguments
            execve_arg = alert['data']['audit']['execve'].get(f'a{i}')
            if execve_arg:  
                execve_args.append(execve_arg)

        if execve_args:  # Si des arguments ont été trouvés
            msg['fields'].append(
                {
                    'title': '💻 Commande',  
                    'value': ' '.join(execve_args),  
                }
            )

    # 7. Ajouter le lien Virustotal, si disponible
    if 'data' in alert and 'virustotal' in alert['data'] and 'permalink' in alert['data']['virustotal']:
        msg['fields'].append(
            {
                'title': '🔗 Lien Virustotal',  
                'value': alert['data']['virustotal']['permalink'],  # Ajouter le lien
            }
        )

    # Ajouter l'horodatage de l'alerte
    msg['ts'] = alert['id']

## Résultat :

![Alertes-exemple](/assets/slack-alerts.png)
