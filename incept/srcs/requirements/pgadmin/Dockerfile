# Utiliser la même image de base que Postgres pour la cohérence
FROM debian:bookworm-slim

# Empêcher les installations interactives
ENV DEBIAN_FRONTEND=noninteractive

# 1. Installer les dépendances de base
RUN apt update && apt install -y \
    wget \
    curl \
    gnupg \
    lsb-release \
    python3 \
    python3-pip \
    libpq5 \
    apache2 \
    libapache2-mod-wsgi-py3 \
    && rm -rf /var/lib/apt/lists/*

# 2. Contournement pour l'erreur "systemctl: command not found"
# Le script setup-web.sh de pgAdmin essaie d'appeler systemctl.
# Nous créons un faux 'systemctl' qui ne fait rien et réussit (exit 0).
RUN ln -s /bin/true /usr/local/bin/systemctl

# 3. Ajouter le dépôt officiel pgAdmin
RUN curl -fsS https://www.pgadmin.org/static/packages_pgadmin_org.pub \
    | gpg --dearmor -o /usr/share/keyrings/packages-pgadmin-org.gpg \
 && echo "deb [signed-by=/usr/share/keyrings/packages-pgadmin-org.gpg] https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main" \
    > /etc/apt/sources.list.d/pgadmin4.list

# 4. Installer pgAdmin
RUN apt update && apt install -y pgadmin4-web && rm -rf /var/lib/apt/lists/*

# 5. Préparer les répertoires pour les volumes
# /var/lib/pgadmin pour la base de données (SQLite) et les sessions
# /var/log/pgadmin pour les logs de l'application
RUN mkdir -p /var/lib/pgadmin /var/log/pgadmin \
 && chown -R www-data:www-data /var/lib/pgadmin /var/log/pgadmin

# 6. Copier et préparer le script d'entrée
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# pgAdmin (via Apache) écoute sur le port 80 à l'intérieur du conteneur
EXPOSE 80

# Démarrer via notre script
ENTRYPOINT ["/entrypoint.sh"]