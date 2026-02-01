# Projet serveur Minecraft - Documentation

## Objectifs du projet

### Fonctionnalités demandées
1. **Cross-play Java/Bedrock** - Permettre aux joueurs Bedrock de rejoindre un serveur Java
2. **Support launchers crackés** - Mode offline pour les comptes non-premium
3. **Seed spécifique** : `-2098004362385192995`
4. **Compatibilité versions futures** - Pouvoir se connecter depuis les nouvelles versions Minecraft
5. **Capacité** : 5 à 10 joueurs

### Infrastructure
- **Hébergement** : Hostinger VPS avec Docker
- **Test local** : Docker sur Windows

---

## Architecture technique prévue

### Stack logicielle
| Composant | Rôle |
|-----------|------|
| **Paper/Purpur** | Serveur Minecraft optimisé avec support plugins |
| **GeyserMC** | Proxy pour traduire le protocole Bedrock → Java |
| **Floodgate** | Authentification des joueurs Bedrock sans compte Java |
| **ViaVersion** | Compatibilité avec les versions Minecraft futures |
| **AuthMe** | Authentification pour sécuriser le mode offline |

### Ports à ouvrir
- `25565` - Port Java (TCP)
- `19132` - Port Bedrock (UDP)

---

## Points d'attention identifiés

### Sécurité (IMPORTANT)
- Avec `online-mode=false`, n'importe qui peut usurper un pseudo
- **AuthMe obligatoire** pour protéger les comptes joueurs
- Envisager une whitelist pour limiter l'accès

### Performance
- RAM recommandée : 3-4 Go minimum pour 10 joueurs + plugins
- Prévoir des backups automatiques du monde

---

## Décisions validées

- [x] AuthMe pour sécuriser les comptes
- [x] Whitelist activée
- [x] Backups automatiques du monde

---

## Historique des décisions

- **2026-01-24** : Définition initiale du projet
- **2026-01-24** : Validation AuthMe, whitelist, backups
- **2026-01-24** : Création de la structure Docker complète

---

## Fichiers créés

| Fichier | Status |
|---------|--------|
| `docker-compose.yml` | ✅ Créé |
| `Dockerfile` | ✅ Créé |
| `scripts/start.sh` | ✅ Créé |
| `scripts/download-plugins.sh` | ✅ Créé |
| `scripts/backup.sh` | ✅ Créé |
| `scripts/mc-health.sh` | ✅ Créé |
| `config/server.properties` | ✅ Créé |
| `config/geyser/config.yml` | ✅ Créé |
| `config/authme/config.yml` | ✅ Créé |
| `.gitignore` | ✅ Créé |
| `.dockerignore` | ✅ Créé |
