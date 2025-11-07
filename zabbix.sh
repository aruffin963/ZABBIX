#!/bin/bash

echo -ne "ZABBIX INSTALLATION \n"

echo -ne "=========================\n\n"

read -p "TAPEZ VOTRE USERNAME  : " name

read -p "TAPEZ VOTRE MOT DE PASSE  : " mdp

read -p "TAPEZ LE NOM DE LA DATABASE A CREE  : " db

echo -ne "\n\n"

echo -ne "Mise à jour des paquets \n=========================\n\n"

sudo apt upgrade && sudo apt update

echo -ne "INSTALLATION DES OUTILS \n=========================\n\n"

sudo apt install wget curl net-tools

sudo apt install -y apache2 mariadb-server php php-cli libapache2-mod-php

sudo apt install -y php-mysql php-xml php-bcmath php-mbstring php-ldap php-json php-gd php-zip php-curl

sudo systemctl enable --now apache2 mariadb
 
echo -ne "SECURISATION DE MARIADB \n=========================\n\n"

sudo mysql_secure_installation

echo -ne "AJOUT DU DEPOT ZABBIX \n=========================\n\n"

wget https://repo.zabbix.com/zabbix/8.0/release/ubuntu/pool/main/z/zabbix-release/zabbix-release_latest_8.0%2Bubuntu24.04_all.deb

sudo dpkg -i zabbix-release_latest_8.0+ubuntu24.04_all.deb

sudo apt update

sudo apt  install -y zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-sql-scripts zabbix-agent

echo -ne "CREATION DE LA BASE DE DONNEE \n=========================\n\n"

sudo mysql -u root

echo -ne "CREATION DE LA BASE DE DONNEE \n"

echo -ne "=========================\n\n 

sudo mysql -u root -e "
CREATE DATABASE $db CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;
CREATE USER '$name'@'localhost' IDENTIFIED BY '$mdp';
GRANT ALL PRIVILEGES ON $db.* TO '$name'@'localhost';
FLUSH PRIVILEGES;
EXIT;"

echo -ne "========FIN DE LA CREATION========\n";

echo -ne "IMPORTATION DU SCHEMA ZABBIX \n=========================\n\n

sudo zcat /usr/share/zabbix/sql-scripts/mysql/server.sql.gz | mysql -u$name -p zabbix


echo -ne "==============================================================\n"

TIMEZONE="Europe/Paris"
APACHE_CONF="/etc/zabbix/apache.conf"
ZABBIX_CONF="/etc/zabbix/zabbix_server.conf"

echo -ne "Mise à jour de $ZABBIX_CONF ...\n"
sudo sed -i "s/^DBUser=.*/DBUser=$name/" "$ZABBIX_CONF"
sudo sed -i "s/^DBPassword=.*/DBPassword=$mdp/" "$ZABBIX_CONF"

grep -q "^DBPassword=" "$ZABBIX_CONF" || echo "DBPassword=$mdp" | sudo tee -a "$ZABBIX_CONF" > /dev/null


if grep -q "php_value date.timezone" "$APACHE_CONF"; then
    sudo sed -i "s|php_value date.timezone .*|php_value date.timezone ${TIMEZONE}|" "$APACHE_CONF"
else
    echo "php_value date.timezone ${TIMEZONE}" | sudo tee -a "$APACHE_CONF" > /dev/null
fi

echo -ne "REDEMARRAGE DES SERVICES\n"

sudo systemctl restart zabbix-server zabbix-agent apache2 mariadb

sudo systemctl enable zabbix-server zabbix-agent apache2 mariadb

sudo systemctl status zabbix-server


echo -ne "DESACTIVATION DES PARE-FEU\n"

sudo ufw allow 80/tcp

sudo ufw allow 22/tcp

sudo ufw status


echo "FIN DE L'INSATALLATION\n"

echo -ne "VERIFICATION DE VOTRE ADRESSE IP\n"

ip a | grep "inet"

echo "ENTREZ ENSUITE VOTRE IP DANS VOTRE NAVIGATEUR: http://votreip/zabbix\n"

echo -ne "CHANGEZ LES CONFIGURATIONS EN SUIVANT CES ETAPES;\n"

echo -ne "1.Database type  : MySQL\n"
echo -ne "2.Database host  : localhost\n"
echo -ne "3.Database port  : 0  (ou laisser vide)\n"
echo -ne "4.Database name  : $db\n"
echo -ne "5.User           : $name\n"
echo -ne "6.Password       : $mdp\n"

echo -ne "7.Zabbix server name : Zabbix-[VotrePrénom]\n"      
echo -ne "8.Default timezone   : Europe/Paris\n"
echo -ne "9.Theme (faites votre choix)              \n"
echo -ne "10.Connexion finale et post-configuration\n"
echo -ne " Username : Admin\n"
echo -ne " Password : zabbix\n"

echo -ne "Après la première installation changez le mot de passe \n"