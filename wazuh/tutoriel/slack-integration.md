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
