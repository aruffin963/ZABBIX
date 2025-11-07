# Scripts d'installation automatique de Zabbix

Ces scripts automatisent l'installation complète de Zabbix 8.0 sur Ubuntu Server 24.04 LTS en deux étapes distinctes : préparation de la base de données et installation des composants Zabbix.

## 🚀 Fonctionnalités

Cette installation automatique est divisée en **deux scripts complémentaires** :

### 📁 Script 1 : `db.sh` - Préparation de la base de données
- **Installation et configuration de MariaDB**
- **Sécurisation automatique de MariaDB**
- **Création de la base de données Zabbix**
- **Création de l'utilisateur avec privilèges appropriés**
- **Vérifications automatiques des résultats**

### 🖥️ Script 2 : `zabbix.sh` - Installation des composants Zabbix
- **Installation de la pile web** (Apache, PHP avec extensions)
- **Installation des composants Zabbix 8.0** (serveur, frontend, agent)
- **Import automatique du schéma Zabbix**
- **Configuration automatique des fichiers** de configuration
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

1. **Téléchargez les scripts** :
   ```bash
   git clone https://github.com/aruffin963/ZABBIX.git
   cd ZABBIX
   ```

2. **Rendez les scripts exécutables** :
   ```bash
   chmod +x db.sh zabbix.sh
   ```

3. **⚠️ IMPORTANT : Exécutez les scripts dans l'ordre suivant** :

   ### Étape 1 : Préparation de la base de données
   ```bash
   ./db.sh
   ```
   
   ### Étape 2 : Installation de Zabbix
   ```bash
   ./zabbix.sh
   ```

   > 📝 **Note** : Le script `zabbix.sh` vous demandera de ressaisir les mêmes informations que dans `db.sh`. Assurez-vous de fournir **exactement les mêmes valeurs**.

## 📝 Utilisation

### 🗃️ Premier script : `db.sh`

Ce script vous demandera de saisir :

1. **Nom de la base de données** à créer (ex: zabbix)
2. **Nom d'utilisateur** pour la base de données Zabbix  
3. **Mot de passe** pour l'utilisateur de la base de données

Le script effectuera automatiquement :
- Installation de MariaDB
- Sécurisation de l'installation MariaDB
- Création de la base de données avec encodage UTF8MB4
- Création de l'utilisateur avec tous les privilèges
- Vérification de la création réussie

### 🖥️ Deuxième script : `zabbix.sh`

Ce script vous demandera de **ressaisir les mêmes informations** configurées lors du premier script :

1. **Nom d'utilisateur** de la base de données (identique à celui créé avec `db.sh`)
2. **Mot de passe** de l'utilisateur (identique à celui défini avec `db.sh`) 
3. **Nom de la base de données** (identique à celle créée avec `db.sh`)

> ⚠️ **Important** : Vous devez renseigner **exactement les mêmes valeurs** que celles utilisées lors de l'exécution de `db.sh`

Le script effectue ensuite automatiquement :

### Étape 1 : Mise à jour du système
- Mise à jour des paquets système
- Installation des outils de base (wget, curl, net-tools)

### Étape 2 : Installation de la pile web
- Apache2 (serveur web)
- PHP avec toutes les extensions requises pour Zabbix

### Étape 3 : Installation de Zabbix
- Ajout du dépôt officiel Zabbix 8.0
- Installation des composants Zabbix (serveur, frontend, agent)

### Étape 4 : Configuration et import des données
- Import automatique du schéma Zabbix dans la base de données existante
- Configuration automatique des fichiers de configuration avec les paramètres saisis
- Définition du fuseau horaire (Europe/Paris)

### Étape 5 : Finalisation
- Démarrage et activation des services
- Configuration du pare-feu (ports 80 et 22)
- Affichage des informations de connexion

## 🌐 Accès à l'interface web

Après l'installation, accédez à Zabbix via votre navigateur :

```
http://votre-adresse-ip/zabbix
```

### Configuration initiale dans l'interface web

Utilisez les **mêmes paramètres** que vous avez saisis dans les deux scripts :

1. **Type de base de données** : MySQL
2. **Hôte de base de données** : localhost
3. **Port de base de données** : 0 (ou laisser vide)
4. **Nom de la base de données** : [même nom utilisé dans `db.sh` et `zabbix.sh`]
5. **Utilisateur** : [même nom d'utilisateur utilisé dans `db.sh` et `zabbix.sh`]
6. **Mot de passe** : [même mot de passe utilisé dans `db.sh` et `zabbix.sh`]
7. **Nom du serveur Zabbix** : Zabbix-[VotrePrénom]
8. **Fuseau horaire par défaut** : Europe/Paris
9. **Thème** : Au choix

### Connexion par défaut

- **Nom d'utilisateur** : `Admin`
- **Mot de passe** : `zabbix`

> ⚠️ **Important** : Changez le mot de passe administrateur après la première connexion !

## 🛠 Services installés

Les scripts configurent les services suivants :

**Après `db.sh` :**
- **mariadb** : Serveur de base de données

**Après `zabbix.sh` :**
- **zabbix-server** : Serveur principal Zabbix
- **zabbix-agent** : Agent Zabbix local
- **apache2** : Serveur web

Tous ces services sont automatiquement démarrés et activés au boot.

## 📊 Composants Zabbix installés

- **Zabbix Server** : Moteur de supervision principal
- **Zabbix Frontend** : Interface web PHP
- **Zabbix Agent** : Agent de supervision local
- **Zabbix SQL Scripts** : Schémas de base de données

## 🔍 Vérification de l'installation

Pour vérifier que l'installation s'est bien déroulée :

**Après `db.sh` :**
```bash
# Vérifier MariaDB
sudo systemctl status mariadb

# Tester la connexion à la base
mysql -u[nom_utilisateur] -p[mot_de_passe] [nom_base]
```

**Après `zabbix.sh` :**
```bash
# Vérifier le statut de tous les services
sudo systemctl status zabbix-server
sudo systemctl status zabbix-agent
sudo systemctl status apache2
sudo systemctl status mariadb

# Vérifier les logs Zabbix
sudo tail -f /var/log/zabbix/zabbix_server.log
```

## 🐛 Dépannage

### Problèmes courants

1. **Erreur "Access denied" lors de l'exécution du script `zabbix.sh`** :
   - Vérifiez que vous avez saisi **exactement les mêmes informations** dans `zabbix.sh` que dans `db.sh`
   - Assurez-vous que MariaDB est démarré : `sudo systemctl status mariadb`

2. **Erreur lors de l'import du schéma Zabbix** :
   - Vérifiez que la base de données créée avec `db.sh` existe : `mysql -u[utilisateur] -p -e "SHOW DATABASES;"`
   - Assurez-vous que les permissions sont correctes

3. **Service Zabbix ne démarre pas** :
   - Vérifiez que les paramètres de base de données dans `/etc/zabbix/zabbix_server.conf` correspondent à ceux saisis
   - Consultez les logs : `/var/log/zabbix/zabbix_server.log`

4. **Interface web inaccessible** :
   - Vérifiez qu'Apache est démarré : `sudo systemctl status apache2`
   - Vérifiez le pare-feu : `sudo ufw status`

5. **Erreur de connexion à la base de données lors de la configuration web** :
   - Vérifiez que vous utilisez **exactement les mêmes paramètres** dans l'interface web que ceux saisis dans les scripts
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