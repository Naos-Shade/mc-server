# CLAUDE.md - Contexte du projet

## Description du projet
Serveur Minecraft Docker avec cross-play Java/Bedrock, support des launchers crackés, et compatibilité versions futures.

## Spécifications techniques

### Objectifs
- Cross-play Java + Bedrock (GeyserMC + Floodgate)
- Mode offline (launchers crackés) sécurisé par AuthMe
- Compatibilité versions futures (ViaVersion)
- Whitelist activée
- Backups automatiques

### Configuration clé
- **Seed** : `-2098004362385192995`
- **Joueurs** : 5-10
- **Port Java** : 25565 (TCP)
- **Port Bedrock** : 19132 (UDP)
- **RAM** : 3-4 Go minimum

### Stack
| Composant | Version | Rôle |
|-----------|---------|------|
| Paper/Purpur | Latest | Serveur Minecraft optimisé |
| GeyserMC | Latest | Proxy Bedrock → Java |
| Floodgate | Latest | Auth Bedrock sans compte Java |
| ViaVersion | Latest | Compat versions futures |
| AuthMe | Latest | Authentification mode offline |

## Infrastructure
- **Production** : Hostinger VPS + Docker
- **Test** : Docker Desktop Windows (local)

## Structure du projet
```
server MC/
├── CLAUDE.md               # Ce fichier - contexte projet
├── PROJET_SERVEUR_MC.md    # Documentation détaillée
├── docker-compose.yml      # Orchestration conteneurs
├── Dockerfile              # Image serveur personnalisée
├── start.sh                # Script démarrage serveur
├── backup.sh               # Script sauvegarde automatique
├── config/                 # Configurations
│   ├── server.properties
│   ├── geyser/
│   ├── floodgate/
│   └── authme/
├── plugins/                # JARs des plugins
├── backups/                # Sauvegardes monde
└── data/                   # Données persistantes (monde, joueurs)
```

## Commandes utiles

### Local (Windows)
```bash
# Démarrer le serveur
docker-compose up -d

# Voir les logs
docker-compose logs -f

# Arrêter le serveur
docker-compose down

# Rebuild après modifications
docker-compose up -d --build
```

### Backups
```bash
# Backup manuel
docker exec mc-server /backup.sh

# Restaurer un backup
# 1. Arrêter le serveur
# 2. Extraire le backup dans data/world
# 3. Redémarrer
```

## Sécurité
- `online-mode=false` → AuthMe OBLIGATOIRE
- Whitelist activée → seuls les pseudos autorisés peuvent joindre
- Backups toutes les 6h

## Notes pour Claude
- Toujours mettre à jour PROJET_SERVEUR_MC.md avec les décisions
- Tester en local avant de déployer sur VPS
- Les plugins doivent être compatibles Paper 1.21.x
