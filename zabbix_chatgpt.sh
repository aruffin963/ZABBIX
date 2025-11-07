#!/bin/bash

set -e  # Stop le script en cas d'erreur

echo -e "\nZABBIX INSTALLATION"
echo -e "=========================\n"

# === Récupération des entrées utilisateur ===
read -p "TAPEZ VOTRE USERNAME  : " name
read -sp "TAPEZ VOTRE MOT DE PASSE  : " mdp
echo
read -p "TAPEZ LE NOM DE LA DATABASE A CREER  : " db
echo

# === MISE À JOUR DU SYSTÈME ===
echo -e "Mise à jour des paquets\n=========================\n"
sudo apt update -y && sudo apt upgrade -y

# === INSTALLATION DES OUTILS ===
echo -e "INSTALLATION DES OUTILS\n=========================\n"
sudo apt install -y wget curl net-tools ufw
sudo apt install -y apache2 mariadb-server php php-cli libapache2-mod-php
sudo apt install -y php-mysql php-xml php-bcmath php-mbstring php-ldap php-json php-gd php-zip php-curl

sudo systemctl enable --now apache2 mariadb

# === SECURISATION DE MARIADB ===
echo -e "SECURISATION DE MARIADB\n=========================\n"
sudo mysql_secure_installation

# === AJOUT DU DEPOT ZABBIX ===
echo -e "AJOUT DU DEPOT ZABBIX\n=========================\n"
wget https://repo.zabbix.com/zabbix/8.0/release/ubuntu/pool/main/z/zabbix-release/zabbix-release_latest_8.0+ubuntu24.04_all.deb
sudo dpkg -i zabbix-release_latest_8.0+ubuntu24.04_all.deb
sudo apt update
sudo apt install -y zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-sql-scripts zabbix-agent

# === CREATION DE LA BASE DE DONNÉES ===
echo -e "CREATION DE LA BASE DE DONNEES\n=========================\n"
sudo mysql -u root <<MYSQL_SCRIPT
CREATE DATABASE ${db} CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;
CREATE USER '${name}'@'localhost' IDENTIFIED BY '${mdp}';
GRANT ALL PRIVILEGES ON ${db}.* TO '${name}'@'localhost';
FLUSH PRIVILEGES;
MYSQL_SCRIPT

echo -e "======== FIN DE LA CREATION ========\n"

# === IMPORTATION DU SCHÉMA ZABBIX ===
echo -e "IMPORTATION DU SCHEMA ZABBIX\n=========================\n"
sudo zcat /usr/share/zabbix/sql-scripts/mysql/server.sql.gz | mysql -u${name} -p${mdp} ${db}

# === CONFIGURATION DES FICHIERS ===
echo -e "MISE À JOUR DES FICHIERS DE CONFIGURATION\n=========================\n"

TIMEZONE="Europe/Paris"
APACHE_CONF="/etc/zabbix/apache.conf"
ZABBIX_CONF="/etc/zabbix/zabbix_server.conf"

# Mise à jour de zabbix_server.conf
sudo sed -i "s/^DBName=.*/DBName=${db}/" "$ZABBIX_CONF"
sudo sed -i "s/^DBUser=.*/DBUser=${name}/" "$ZABBIX_CONF"
sudo sed -i "s/^DBPassword=.*/DBPassword=${mdp}/" "$ZABBIX_CONF"

grep -q "^DBPassword=" "$ZABBIX_CONF" || echo "DBPassword=${mdp}" | sudo tee -a "$ZABBIX_CONF" > /dev/null

# Mise à jour du fuseau horaire PHP
if grep -q "php_value date.timezone" "$APACHE_CONF"; then
    sudo sed -i "s|php_value date.timezone .*|php_value date.timezone ${TIMEZONE}|" "$APACHE_CONF"
else
    echo "php_value date.timezone ${TIMEZONE}" | sudo tee -a "$APACHE_CONF" > /dev/null
fi

# === REDEMARRAGE DES SERVICES ===
echo -e "REDEMARRAGE DES SERVICES\n=========================\n"
sudo systemctl restart zabbix-server zabbix-agent apache2 mariadb
sudo systemctl enable zabbix-server zabbix-agent apache2 mariadb

# === CONFIGURATION DU PARE-FEU ===
echo -e "CONFIGURATION DU PARE-FEU\n=========================\n"
sudo ufw allow 80/tcp
sudo ufw allow 22/tcp
sudo ufw reload
sudo ufw status

# === INFORMATIONS FINALES ===
echo -e "\nFIN DE L'INSTALLATION\n=========================\n"
echo -e "VERIFICATION DE VOTRE ADRESSE IP :\n"
ip -4 addr show | grep inet

echo -e "\n👉 Entrez ensuite votre IP dans votre navigateur : http://votre_ip/zabbix\n"

echo -e "CONFIGURATION WEB À SUIVRE :\n============================"
echo -e "1. Database type   : MySQL"
echo -e "2. Database host   : localhost"
echo -e "3. Database port   : 0 (ou laisser vide)"
echo -e "4. Database name   : ${db}"
echo -e "5. User            : ${name}"
echo -e "6. Password        : ${mdp}"
echo -e "7. Zabbix server name : Zabbix-[VotrePrénom]"
echo -e "8. Default timezone   : Europe/Paris"
echo -e "9. Theme : à votre choix"
echo -e "10. Connexion finale :"
echo -e "   Username : Admin"
echo -e "   Password : zabbix"
echo -e "\n💡 Après la première connexion, changez le mot de passe Admin.\n"
