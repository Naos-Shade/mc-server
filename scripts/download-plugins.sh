#!/bin/bash

# ===========================================
# Script de téléchargement des plugins
# ===========================================

PLUGINS_DIR="/server/data/plugins"
mkdir -p "${PLUGINS_DIR}"

download_if_missing() {
    local name="$1"
    local url="$2"
    local filename="$3"

    if [ ! -f "${PLUGINS_DIR}/${filename}" ]; then
        echo "[INFO] Téléchargement de ${name}..."
        curl -L -o "${PLUGINS_DIR}/${filename}" "${url}"
        echo "[OK] ${name} téléchargé"
    else
        echo "[OK] ${name} déjà présent"
    fi
}

echo "=========================================="
echo "  Téléchargement des plugins"
echo "=========================================="

# GeyserMC (Cross-play Bedrock)
GEYSER_URL="https://download.geysermc.org/v2/projects/geyser/versions/latest/builds/latest/downloads/spigot"
download_if_missing "GeyserMC" "${GEYSER_URL}" "Geyser-Spigot.jar"

# Floodgate (Auth Bedrock sans compte Java)
FLOODGATE_URL="https://download.geysermc.org/v2/projects/floodgate/versions/latest/builds/latest/downloads/spigot"
download_if_missing "Floodgate" "${FLOODGATE_URL}" "floodgate-spigot.jar"

# ViaVersion (Compatibilité versions futures)
# On récupère la dernière version depuis GitHub
echo "[INFO] Récupération de la dernière version de ViaVersion..."
VIA_VERSION=$(curl -s "https://api.github.com/repos/ViaVersion/ViaVersion/releases/latest" | jq -r '.tag_name')
if [ "${VIA_VERSION}" != "null" ] && [ -n "${VIA_VERSION}" ]; then
    VIA_URL="https://github.com/ViaVersion/ViaVersion/releases/download/${VIA_VERSION}/ViaVersion-${VIA_VERSION}.jar"
    download_if_missing "ViaVersion" "${VIA_URL}" "ViaVersion.jar"
else
    echo "[WARN] Impossible de récupérer ViaVersion depuis GitHub, utilisation du lien direct..."
    VIA_URL="https://hangarcdn.papermc.io/plugins/ViaVersion/ViaVersion/versions/5.2.1/PAPER/ViaVersion-5.2.1.jar"
    download_if_missing "ViaVersion" "${VIA_URL}" "ViaVersion.jar"
fi

echo "=========================================="
echo "  Plugins prêts!"
echo "=========================================="
ls -la "${PLUGINS_DIR}"
