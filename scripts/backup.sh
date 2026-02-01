#!/bin/bash

# ===========================================
# Script de backup du serveur Minecraft
# ===========================================

BACKUP_DIR="/server/backups"
DATA_DIR="/server/data"
WORLD_NAME="world"
MAX_BACKUPS=10

# Format de date pour le nom du backup
DATE=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_NAME="backup_${DATE}.tar.gz"

echo "=========================================="
echo "  Backup du monde Minecraft"
echo "  Date: ${DATE}"
echo "=========================================="

# Créer le dossier de backup si nécessaire
mkdir -p "${BACKUP_DIR}"

# Vérifier que le monde existe
if [ ! -d "${DATA_DIR}/${WORLD_NAME}" ]; then
    echo "[WARN] Le monde '${WORLD_NAME}' n'existe pas encore, backup ignoré"
    exit 0
fi

# Créer le backup
echo "[INFO] Création du backup..."
cd "${DATA_DIR}"

# Sauvegarder le monde + les données importantes
tar -czf "${BACKUP_DIR}/${BACKUP_NAME}" \
    "${WORLD_NAME}" \
    "${WORLD_NAME}_nether" \
    "${WORLD_NAME}_the_end" \
    "whitelist.json" \
    "ops.json" \
    "banned-players.json" \
    "banned-ips.json" \
    2>/dev/null || true

# Vérifier que le backup a été créé
if [ -f "${BACKUP_DIR}/${BACKUP_NAME}" ]; then
    SIZE=$(du -h "${BACKUP_DIR}/${BACKUP_NAME}" | cut -f1)
    echo "[OK] Backup créé: ${BACKUP_NAME} (${SIZE})"
else
    echo "[ERROR] Échec de la création du backup"
    exit 1
fi

# Rotation des backups (garder les X derniers)
echo "[INFO] Rotation des backups (max: ${MAX_BACKUPS})..."
cd "${BACKUP_DIR}"
BACKUP_COUNT=$(ls -1 backup_*.tar.gz 2>/dev/null | wc -l)

if [ "${BACKUP_COUNT}" -gt "${MAX_BACKUPS}" ]; then
    TO_DELETE=$((BACKUP_COUNT - MAX_BACKUPS))
    ls -1t backup_*.tar.gz | tail -n "${TO_DELETE}" | xargs rm -f
    echo "[OK] ${TO_DELETE} ancien(s) backup(s) supprimé(s)"
fi

# Afficher les backups existants
echo ""
echo "Backups disponibles:"
ls -lh "${BACKUP_DIR}"/backup_*.tar.gz 2>/dev/null || echo "Aucun backup"

echo "=========================================="
echo "  Backup terminé!"
echo "=========================================="
