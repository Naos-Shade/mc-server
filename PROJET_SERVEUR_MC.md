# Projet serveur Minecraft - Documentation

## Objectifs du projet

### Fonctionnalités demandées
1. **Cross-play Java/Bedrock** - Permettre aux joueurs Bedrock de rejoindre un serveur Java
2. **Support launchers crackés** - Mode offline pour les comptes non-premium
3. **Seed spécifique** : `-2098004362385192995`
4. **Compatibilité versions futures** - Pouvoir se connecter depuis les nouvelles versions Minecraft
5. **Capacité** : 5 à 10 joueurs
6. **Panel Web** - Interface pour gérer la whitelist

### Infrastructure
- **Hébergement** : Hostinger VPS avec Docker
- **Test local** : Docker sur Windows

---

## Serveur de Production

### Informations de connexion
| Service | Adresse | Port |
|---------|---------|------|
| **Minecraft Java** | `31.97.54.147` | `25565` |
| **Minecraft Bedrock** | `31.97.54.147` | `19132` (UDP) |
| **Panel Whitelist** | http://31.97.54.147:8080 | `8080` |
| **RCON** | `127.0.0.1` (interne) | `25575` |

### Identifiants
- **Panel Whitelist** : `123Soan123`
- **RCON Password** : `ChangeMe_SecurePassword123`

### VPS Hostinger
- **ID** : 844847
- **IP** : 31.97.54.147
- **Hostname** : srv844847.hstgr.cloud

---

## Repos GitHub

| Repo | URL | Description |
|------|-----|-------------|
| **Serveur MC** | https://github.com/Naos-Shade/mc-server | Serveur Minecraft Docker |
| **Panel Whitelist** | https://github.com/Naos-Shade/mc-whitelist-panel | Interface web de gestion |

---

## Architecture technique

### Stack logicielle
| Composant | Version | Rôle |
|-----------|---------|------|
| **Paper** | 1.21.1 | Serveur Minecraft optimisé |
| **GeyserMC** | Latest | Proxy Bedrock → Java |
| **Floodgate** | Latest | Auth Bedrock sans compte Java |
| **ViaVersion** | Latest | Compat versions futures |
| **SkinsRestorer** | Latest | Gestion des skins |

### Ports exposés
- `25565/TCP` - Port Java
- `19132/UDP` - Port Bedrock (Geyser)
- `25575/TCP` - Port RCON
- `8080/TCP` - Panel Whitelist

---

## Panel Whitelist

### Fonctionnalités
- Connexion sécurisée par mot de passe
- Ajout de joueurs Java et Bedrock
- Suppression de joueurs
- Affichage du statut serveur (joueurs en ligne)
- Communication via RCON avec le serveur

### Notes techniques
- Les joueurs Bedrock ont un préfixe `.` (ajouté automatiquement)
- Le panel utilise `network_mode: host` pour accéder au RCON local

---

## Connexion Nintendo Switch / Consoles

Sur Nintendo Switch, Xbox et PlayStation, les serveurs custom ne sont pas accessibles directement. Il faut utiliser **BedrockConnect** :

### Configuration DNS (Switch/Xbox/PS)
1. Aller dans les paramètres réseau
2. Configurer le DNS manuellement :
   - **DNS Primaire** : `104.238.130.180`
   - **DNS Secondaire** : `8.8.8.8`

### Se connecter
1. Lancer Minecraft
2. Aller dans Jouer → Serveurs
3. Cliquer sur un serveur "Featured" (Hive, Mineplex...)
4. Le menu BedrockConnect s'affiche
5. Choisir "Connect to a Server"
6. Entrer : `31.97.54.147` port `19132`

---

## Joueurs whitelistés

| Pseudo | Plateforme |
|--------|------------|
| .MDJB3RJB | Bedrock |
| Nyser92 | Java |
| LouneGaming | Java |
| Naos_Shade | Java |

---

## Commandes utiles

### Gestion Docker (sur VPS via Hostinger)
```bash
# Voir les logs
docker logs mc-server -f

# Redémarrer le serveur
docker restart mc-server

# Console Minecraft
docker attach mc-server
# (Ctrl+P, Ctrl+Q pour sortir)
```

### Commandes Minecraft (via RCON ou console)
```
whitelist add <pseudo>     # Ajouter un joueur
whitelist remove <pseudo>  # Retirer un joueur
whitelist list             # Liste des joueurs
list                       # Joueurs en ligne
op <pseudo>                # Donner les droits admin
```

---

## Sécurité

- `online-mode=false` - Mode cracké activé
- **Whitelist activée** - Seuls les joueurs autorisés peuvent rejoindre
- **AuthMe désactivé** (supprimé car causait des problèmes)
- Backups automatiques toutes les 6h

---

## Historique des modifications

- **2026-01-24** : Création initiale du projet
- **2026-01-24** : Configuration Docker complète
- **2026-01-31** : Déploiement sur Hostinger VPS
- **2026-02-01** : Création du panel whitelist
- **2026-02-01** : Activation du RCON
- **2026-02-01** : Création des repos GitHub
- **2026-02-01** : Fix interface panel (input CSS)

---

## Fichiers du projet

```
server MC/
├── CLAUDE.md                    # Instructions pour Claude
├── PROJET_SERVEUR_MC.md         # Cette documentation
├── docker-compose.yml           # Config Docker serveur
├── Dockerfile                   # Image serveur
├── .gitignore
├── config/
│   ├── server.properties        # Config Minecraft
│   ├── geyser/config.yml        # Config GeyserMC
│   └── authme/config.yml        # Config AuthMe (désactivé)
├── scripts/
│   ├── start.sh                 # Script démarrage (avec RCON)
│   ├── download-plugins.sh      # Téléchargement plugins
│   ├── backup.sh                # Sauvegarde automatique
│   └── mc-health.sh             # Health check
└── panel/                       # Panel Whitelist (repo séparé)
    ├── docker-compose.yml
    ├── Dockerfile
    ├── package.json
    ├── server.js                # Backend Express + RCON
    └── public/index.html        # Interface web
```
