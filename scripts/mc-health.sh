#!/bin/bash

# ===========================================
# Health check pour le serveur Minecraft
# ===========================================

# Vérifier si le processus Java tourne
if pgrep -f "paper.jar" > /dev/null; then
    exit 0
else
    exit 1
fi
