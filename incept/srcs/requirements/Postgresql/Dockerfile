FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

# Installe les dépendances et PostgreSQL 18
RUN apt update && apt install -y \
      wget \
      gnupg \
      lsb-release
RUN wget -qO- https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor > /usr/share/keyrings/pgdg.gpg \
 && echo "deb [signed-by=/usr/share/keyrings/pgdg.gpg] http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" \
     > /etc/apt/sources.list.d/pgdg.list \
 && apt update \
 && apt install -y postgresql-18 \
 && rm -rf /var/lib/apt/lists/*

# Initialise le répertoire de données et configure PostgreSQL
RUN rm -rf /var/lib/postgresql/18/main && \
    mkdir -p /var/lib/postgresql/18/main && \
    chown postgres:postgres /var/lib/postgresql/18/main && \
    su - postgres -c "/usr/lib/postgresql/18/bin/initdb -D /var/lib/postgresql/18/main" && \
    echo "listen_addresses = '*'" >> /var/lib/postgresql/18/main/postgresql.conf

# Copie le script d'entrée
COPY entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

USER postgres

RUN echo "host all all 0.0.0.0/0 trust" >> /var/lib/postgresql/18/main/pg_hba.conf

# 'trust' signifie qu'aucun mot de passe n'est demandé (dangereux en production, mais simple pour un projet local)

# Si vous voulez une meilleure sécurité :
# RUN echo "host all all 0.0.0.0/0 md5" >> /var/lib/postgresql/18/main/pg_hba.conf
# 'md5' requiert le mot de passe, ce qui est recommandé.
RUN echo "host all all 0.0.0.0/0 md5" >> /var/lib/postgresql/18/main/pg_hba.conf

#USER postgres
#VOLUME /var/lib/postgresql/18/main
EXPOSE 5432

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/lib/postgresql/18/bin/postgres", "-D", "/var/lib/postgresql/18/main"]

