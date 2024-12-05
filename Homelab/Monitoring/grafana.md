# 🎯 Suivi des Performances du Serveur

> Le but est d'avoir un suivi des performances du serveur.

- **Prometheus** est un outil de surveillance des systèmes qui collecte et stocke des métriques
- **Grafana** est utilisé pour visualiser ces données sous forme de graphiques et de tableaux de bord interactifs.
- **Node Exporter** fait le liens entre Promtheus et grafana.

## 🛠️ **Installation et Configuration : Prometheus + Grafana**

### Installer Prometheus
```bash

sudo apt update
sudo apt install prometheus
```

### Configurer Prometheus
```bash

sudo nano /etc/prometheus/prometheus.yml
```

### Installer Grafana

```bash

sudo apt install -y software-properties-common
sudo add-apt-repository "deb https://packages.grafana.com/oss/deb stable main"
sudo apt update
sudo apt install grafana
```

### Démarrer et activer Grafana

```bash

sudo systemctl start grafana-server
sudo systemctl enable grafana-server
```

### Installer Node Exporter
```bash

wget https://github.com/prometheus/node_exporter/releases/download/v1.6.1/node_exporter-1.6.1.linux-amd64.tar.gz
tar -xvzf node_exporter-1.6.1.linux-amd64.tar.gz
cd node_exporter-1.6.1.linux-amd64
./node_exporter &
```

### Autoriser le pare-feu
```bash

sudo ufw allow 3000 # Grafana 
sudo ufw allow 9090 # Prometheus 
sudo ufw allow 9100 # Node Exporter 
```

### Connexion à Grafana
`http://localhost:3000`

## ⚙️ Ajouter Prometheus comme source de données dans Grafana
- Allez dans Configuration > Data Sources.
-  Cliquez sur Add data source.
- Recherchez Prometheus.
- Configurez la source de données :
- URL : http://localhost:9090
- Cliquez sur Save & Test pour vérifier que Grafana peut se connecter à Prometheus.

![illustration](/assets/grafana1.png)

## 📈 Importer un Dashboard
 - Dans Dashboard > New > Import
 - Entrez l'ID du dashboard

### 🔗 [Trouver des Dashboards](https://grafana.com/grafana/dashboards/)

