FROM eclipse-temurin:21-jdk-alpine

# Métadonnées
LABEL maintainer="soanp"
LABEL description="Serveur Minecraft Paper avec GeyserMC, Floodgate, ViaVersion, AuthMe"

# Variables d'environnement
ENV MIN_RAM=2G
ENV MAX_RAM=4G
ENV PAPER_VERSION=1.21.1
ENV PAPER_BUILD=latest

# Installer les dépendances
RUN apk add --no-cache \
    curl \
    jq \
    bash \
    tar \
    gzip \
    coreutils

# Créer l'utilisateur minecraft
RUN addgroup -g 1000 minecraft && \
    adduser -u 1000 -G minecraft -h /server -D minecraft

# Créer les répertoires
WORKDIR /server
RUN mkdir -p data plugins config backups && \
    chown -R minecraft:minecraft /server

# Script de téléchargement des plugins
COPY --chown=minecraft:minecraft scripts/download-plugins.sh /server/
RUN chmod +x /server/download-plugins.sh

# Script de démarrage
COPY --chown=minecraft:minecraft scripts/start.sh /server/
RUN chmod +x /server/start.sh

# Script de backup
COPY --chown=minecraft:minecraft scripts/backup.sh /server/
RUN chmod +x /server/backup.sh

# Script health check
COPY --chown=minecraft:minecraft scripts/mc-health.sh /usr/local/bin/mc-health
RUN chmod +x /usr/local/bin/mc-health

# Exposer les ports
EXPOSE 25565
EXPOSE 19132/udp

# Utilisateur non-root
USER minecraft

# Point d'entrée
ENTRYPOINT ["/server/start.sh"]
