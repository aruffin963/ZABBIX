#!/bin/bash

set -e  # Arrête le script en cas d'erreur

echo -e "\n=== INSTALLATION DE LA BASE DE DONNÉES ZABBIX ===\n"

sudo apt install -y mariadb-server

sudo systemctl enable --now mariadb

# === Récupération des entrées ===
read -p "Nom de la base à créer : " db
read -p "Nom d'utilisateur à créer : " name
read -sp "Mot de passe de l'utilisateur : " mdp
echo -e "\n"

# === Vérification de MariaDB/MySQL ===
if ! command -v mysql &> /dev/null; then
    echo "MySQL/MariaDB n'est pas installé. Installation en cours..."
    sudo apt update -y && sudo apt install -y mariadb-server
    sudo systemctl enable --now mariadb
fi

# === Sécurisation basique de MariaDB (si pas déjà fait) ===
echo -e "\nVérification de la sécurité MariaDB..."
sudo mysql_secure_installation

# === Création de la base et de l'utilisateur ===
echo -e "\nCréation de la base de données et de l'utilisateur..."

sudo mysql -u root <<EOF
CREATE DATABASE IF NOT EXISTS ${db} CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;
CREATE USER IF NOT EXISTS '${name}'@'localhost' IDENTIFIED BY '${mdp}';
GRANT ALL PRIVILEGES ON ${db}.* TO '${name}'@'localhost';
FLUSH PRIVILEGES;
EOF

# === Vérification de la création ===
echo -e "\nVérification des résultats :"
sudo mysql -u root -e "SHOW DATABASES LIKE '${db}';"
sudo mysql -u root -e "SELECT user, host FROM mysql.user WHERE user='${name}';"

echo -e "\nBase de données '${db}' et utilisateur '${name}' créés avec succès.\n"
