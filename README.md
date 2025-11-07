# Script d'installation automatique de Zabbix

Ce script automatise l'installation complète de Zabbix 8.0 sur Ubuntu Server 24.04 LTS, incluant la configuration de la base de données, du serveur web et de tous les composants nécessaires.

## 🚀 Fonctionnalités

Ce script d'installation automatique prend en charge :

- **Installation complète de Zabbix 8.0** avec tous ses composants
- **Configuration automatique de la pile LAMP** (Apache, MariaDB, PHP)
- **Création automatique de la base de données** avec l'utilisateur configuré
- **Configuration des fichiers de configuration** Zabbix et Apache
- **Démarrage et activation des services** système
- **Configuration du pare-feu** pour l'accès web
- **Guide de configuration post-installation**

## 📋 Prérequis

- **Système d'exploitation** : Ubuntu Server 24.04 LTS
- **Privilèges** : Accès sudo/root
- **Connectivité** : Accès Internet pour télécharger les paquets
- **RAM** : Minimum 2 GB recommandé
- **Espace disque** : Minimum 10 GB disponible

## 🔧 Installation

1. **Téléchargez le script** :
   ```bash
   wget https://raw.githubusercontent.com/aruffin963/ZABBIX/main/zabbix.sh
   # ou clonez le repository
   git clone https://github.com/aruffin963/ZABBIX.git
   ```

2. **Rendez le script exécutable** :
   ```bash
   chmod +x zabbix.sh
   ```

3. **Exécutez le script** :
   ```bash
   ./zabbix.sh
   ```

## 📝 Utilisation

Lors de l'exécution, le script vous demandera de saisir :

1. **Nom d'utilisateur** de la base de données Zabbix
2. **Mot de passe** pour l'utilisateur de la base de données
3. **Nom de la base de données** à créer (ex: zabbix)

Le script effectuera ensuite automatiquement :

### Étape 1 : Mise à jour du système
- Mise à jour des paquets système
- Installation des outils de base (wget, curl, net-tools)

### Étape 2 : Installation de la pile LAMP
- Apache2 (serveur web)
- MariaDB (serveur de base de données)
- PHP avec toutes les extensions requises

### Étape 3 : Sécurisation de MariaDB
- Exécution de `mysql_secure_installation`

### Étape 4 : Installation de Zabbix
- Ajout du dépôt officiel Zabbix 8.0
- Installation des composants Zabbix (serveur, frontend, agent)

### Étape 5 : Configuration de la base de données
- Création automatique de la base de données
- Création de l'utilisateur avec les privilèges appropriés
- Import du schéma Zabbix

### Étape 6 : Configuration des services
- Configuration automatique des fichiers de configuration
- Définition du fuseau horaire (Europe/Paris)
- Démarrage et activation des services

### Étape 7 : Configuration du pare-feu
- Autorisation du trafic HTTP (port 80)
- Autorisation du trafic SSH (port 22)

## 🌐 Accès à l'interface web

Après l'installation, accédez à Zabbix via votre navigateur :

```
http://votre-adresse-ip/zabbix
```

### Configuration initiale dans l'interface web

1. **Type de base de données** : MySQL
2. **Hôte de base de données** : localhost
3. **Port de base de données** : 0 (ou laisser vide)
4. **Nom de la base de données** : [nom choisi pendant l'installation]
5. **Utilisateur** : [nom d'utilisateur choisi pendant l'installation]
6. **Mot de passe** : [mot de passe choisi pendant l'installation]
7. **Nom du serveur Zabbix** : Zabbix-[VotrePrénom]
8. **Fuseau horaire par défaut** : Europe/Paris
9. **Thème** : Au choix

### Connexion par défaut

- **Nom d'utilisateur** : `Admin`
- **Mot de passe** : `zabbix`

> ⚠️ **Important** : Changez le mot de passe administrateur après la première connexion !

## 🛠 Services installés

Le script configure les services suivants :

- **zabbix-server** : Serveur principal Zabbix
- **zabbix-agent** : Agent Zabbix local
- **apache2** : Serveur web
- **mariadb** : Serveur de base de données

Tous ces services sont automatiquement démarrés et activés au boot.

## 📊 Composants Zabbix installés

- **Zabbix Server** : Moteur de supervision principal
- **Zabbix Frontend** : Interface web PHP
- **Zabbix Agent** : Agent de supervision local
- **Zabbix SQL Scripts** : Schémas de base de données

## 🔍 Vérification de l'installation

Pour vérifier que l'installation s'est bien déroulée :

```bash
# Vérifier le statut des services
sudo systemctl status zabbix-server
sudo systemctl status zabbix-agent
sudo systemctl status apache2
sudo systemctl status mariadb

# Vérifier les logs Zabbix
sudo tail -f /var/log/zabbix/zabbix_server.log
```

## 🐛 Dépannage

### Problèmes courants

1. **Service Zabbix ne démarre pas** :
   - Vérifiez la configuration de la base de données
   - Consultez les logs : `/var/log/zabbix/zabbix_server.log`

2. **Interface web inaccessible** :
   - Vérifiez qu'Apache est démarré : `sudo systemctl status apache2`
   - Vérifiez le pare-feu : `sudo ufw status`

3. **Erreur de connexion à la base de données** :
   - Vérifiez les paramètres dans `/etc/zabbix/zabbix_server.conf`
   - Testez la connexion : `mysql -u[utilisateur] -p[mot_de_passe] [base_de_données]`

### Logs utiles

- **Zabbix Server** : `/var/log/zabbix/zabbix_server.log`
- **Apache** : `/var/log/apache2/error.log`
- **MariaDB** : `/var/log/mysql/error.log`

## 📄 Licence

Ce script est fourni "tel quel" sans garantie. Utilisez-le à vos propres risques et testez-le dans un environnement de développement avant de l'utiliser en production.

## 🤝 Contribution

Les contributions sont les bienvenues ! N'hésitez pas à :
- Signaler des bugs
- Proposer des améliorations
- Soumettre des pull requests

---

**Auteur** : aruffin963  
**Version Zabbix** : 8.0  
**Système supporté** : Ubuntu Server 24.04 LTS