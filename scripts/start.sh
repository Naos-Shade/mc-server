#!/bin/bash

# ===========================================
# Script de démarrage du serveur Minecraft
# ===========================================

set -e

SERVER_DIR="/server"
DATA_DIR="${SERVER_DIR}/data"
PLUGINS_DIR="${DATA_DIR}/plugins"
CONFIG_DIR="${SERVER_DIR}/config"

echo "=========================================="
echo "  Démarrage du serveur Minecraft"
echo "=========================================="

# Créer les répertoires si nécessaire
mkdir -p "${DATA_DIR}" "${PLUGINS_DIR}"

# Télécharger Paper si absent
if [ ! -f "${DATA_DIR}/paper.jar" ]; then
    echo "[INFO] Téléchargement de Paper ${PAPER_VERSION}..."

    # Récupérer le dernier build
    if [ "${PAPER_BUILD}" = "latest" ]; then
        PAPER_BUILD=$(curl -s "https://api.papermc.io/v2/projects/paper/versions/${PAPER_VERSION}/builds" | jq -r '.builds[-1].build')
    fi

    PAPER_JAR="paper-${PAPER_VERSION}-${PAPER_BUILD}.jar"
    curl -o "${DATA_DIR}/paper.jar" \
        "https://api.papermc.io/v2/projects/paper/versions/${PAPER_VERSION}/builds/${PAPER_BUILD}/downloads/${PAPER_JAR}"

    echo "[OK] Paper téléchargé"
fi

# Télécharger les plugins
echo "[INFO] Vérification des plugins..."
/server/download-plugins.sh

# Copier server.properties si absent
if [ ! -f "${DATA_DIR}/server.properties" ]; then
    echo "[INFO] Copie de server.properties..."
    cp "${CONFIG_DIR}/server.properties" "${DATA_DIR}/"
fi

# Activer RCON dans server.properties
echo "[INFO] Configuration RCON..."
if grep -q "^enable-rcon=" "${DATA_DIR}/server.properties"; then
    sed -i 's/^enable-rcon=.*/enable-rcon=true/' "${DATA_DIR}/server.properties"
else
    echo "enable-rcon=true" >> "${DATA_DIR}/server.properties"
fi

if grep -q "^rcon.port=" "${DATA_DIR}/server.properties"; then
    sed -i 's/^rcon.port=.*/rcon.port=25575/' "${DATA_DIR}/server.properties"
else
    echo "rcon.port=25575" >> "${DATA_DIR}/server.properties"
fi

if grep -q "^rcon.password=" "${DATA_DIR}/server.properties"; then
    sed -i 's/^rcon.password=.*/rcon.password=ChangeMe_SecurePassword123/' "${DATA_DIR}/server.properties"
else
    echo "rcon.password=ChangeMe_SecurePassword123" >> "${DATA_DIR}/server.properties"
fi
echo "[OK] RCON activé sur le port 25575"

# Accepter l'EULA
echo "eula=true" > "${DATA_DIR}/eula.txt"

# Copier les configs des plugins si elles existent
if [ -d "${CONFIG_DIR}/geyser" ] && [ ! -d "${PLUGINS_DIR}/Geyser-Spigot" ]; then
    mkdir -p "${PLUGINS_DIR}/Geyser-Spigot"
fi
if [ -f "${CONFIG_DIR}/geyser/config.yml" ]; then
    cp "${CONFIG_DIR}/geyser/config.yml" "${PLUGINS_DIR}/Geyser-Spigot/"
fi

if [ -d "${CONFIG_DIR}/floodgate" ] && [ ! -d "${PLUGINS_DIR}/floodgate" ]; then
    mkdir -p "${PLUGINS_DIR}/floodgate"
fi

if [ -d "${CONFIG_DIR}/authme" ] && [ ! -d "${PLUGINS_DIR}/AuthMe" ]; then
    mkdir -p "${PLUGINS_DIR}/AuthMe"
fi
if [ -f "${CONFIG_DIR}/authme/config.yml" ]; then
    cp "${CONFIG_DIR}/authme/config.yml" "${PLUGINS_DIR}/AuthMe/"
fi

# Lancer le backup automatique en arrière-plan
echo "[INFO] Activation des backups automatiques (toutes les 6h)..."
(
    while true; do
        sleep 21600  # 6 heures
        /server/backup.sh
    done
) &

# Démarrer le serveur
cd "${DATA_DIR}"
echo "[INFO] Lancement du serveur avec RAM: ${MIN_RAM} - ${MAX_RAM}"
echo "=========================================="

exec java \
    -Xms${MIN_RAM} \
    -Xmx${MAX_RAM} \
    -XX:+UseG1GC \
    -XX:+ParallelRefProcEnabled \
    -XX:MaxGCPauseMillis=200 \
    -XX:+UnlockExperimentalVMOptions \
    -XX:+DisableExplicitGC \
    -XX:+AlwaysPreTouch \
    -XX:G1NewSizePercent=30 \
    -XX:G1MaxNewSizePercent=40 \
    -XX:G1HeapRegionSize=8M \
    -XX:G1ReservePercent=20 \
    -XX:G1HeapWastePercent=5 \
    -XX:G1MixedGCCountTarget=4 \
    -XX:InitiatingHeapOccupancyPercent=15 \
    -XX:G1MixedGCLiveThresholdPercent=90 \
    -XX:G1RSetUpdatingPauseTimePercent=5 \
    -XX:SurvivorRatio=32 \
    -XX:+PerfDisableSharedMem \
    -XX:MaxTenuringThreshold=1 \
    -Dusing.aikars.flags=https://mcflags.emc.gs \
    -Daikars.new.flags=true \
    -jar paper.jar \
    --nogui
