#!/bin/bash

# Script: SIEM Detection Testsuite
# Description: Test des règles SIEM avec des commandes réseau
# Auteur: CupOfCoffeeX

#!/bin/bash

# Script: SIEM Detection Testsuite avec suppression des outputs et gestion des erreurs
# Auteur: [Votre Nom]

# Fonction pour afficher une barre de chargement
progress_bar() {
    local duration=$1
    local bar="####################"
    local n=${#bar}
    for ((i=0; i<=n; i++)); do
        printf "\r[%-${n}s] %d%%" "${bar:0:i}" $((i * 100 / n))
        sleep $((duration / n))
    done
    echo ""
}

# Couleur verte pour les commandes, rouge pour les erreurs
GREEN="\033[0;32m"
RED="\033[0;31m"
RESET="\033[0m"

# Fonction pour exécuter une commande en silence avec gestion d'erreur
execute_command() {
    local cmd="$1"
    local emoji="$2"
    local name="$3"

    echo -e "${emoji} ${GREEN}Exécution de ${name}...${RESET}"
    progress_bar 2

    # Exécuter la commande en silence et vérifier son statut
    eval "$cmd #testsuite" > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ Erreur : La commande ${name} a échoué.${RESET}"
    fi
}

echo -e "\n🔍 Début de la testsuite SIEM pour les commandes réseau...\n"

# Liste des commandes à exécuter
execute_command "netstat -an" "🛠️" "netstat"
execute_command "ss -tulnp" "🔧" "ss"
execute_command "route -n" "🗺️" "route"
execute_command "dig google.com" "🌐" "dig"
execute_command "nslookup google.com" "🔍" "nslookup"
execute_command "traceroute google.com" "📍" "traceroute"
execute_command "arp -a" "🖧" "arp"
execute_command "(echo 'quit') | telnet 127.0.0.1 80" "📡" "telnet"

echo -e "\n✅ ${GREEN}Fin de la testsuite SIEM.${RESET}\n"

