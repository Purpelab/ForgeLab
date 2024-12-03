# ToDo 
- ~~**slack et génération d'alerte -  FAIT + TUTO**~~
- template rapport + conclusion ou d'autres champs intéressant a ajouter
- mettre en place une testsuite pour tester les règles déjà implémentés lorsqu'on en ajoute de nouvelles
- ~~**Monitorer l'integrité de fichier (voir le tuto fait)**~~ - Il faut voir si on monitore /tmp
- monitorer l'accès a un repertoire
- monitorer la lecture d'un fichier
- Creation de "project" dans github afin d'y integrer la toDo (template team planning ou launch ....) on peut modifier (todo, in progress, done, amelioration)
- https://github.com/wazuh/wazuh-dashboard-plugins - Intégrer le plugin dashboard
- honeypot
- monitorer l'acces a un compte utilisateur
- monitorer plusieurs chaine de caractere 
- bypass 
- Privec


## Archi 

/cheatsheet -tools
├── Blue tags osint - siem 
├── actualités tags cve géopolitique - attaque - Dinguerie
└── Divertissement tags liens /  serié
└── CTI - purple


# Wazuh Rules 

Surveillance de l'intégrité des fichiers

https://documentation.wazuh.com/current/compliance/nist/file-integrity-monitoring.html


Détection de changement de ports : (inconvénient : utilise la commande netstat donc impossible de la monitorer) - voir risque / benefice
https://documentation.wazuh.com/current/user-manual/capabilities/command-monitoring/use-cases/check-if-the-output-changed.html


