#!/bin/bash

# Démarre PostgreSQL en arrière-plan
/usr/lib/postgresql/18/bin/postgres -D /var/lib/postgresql/18/main &
PID=$!

# Attend que PostgreSQL soit prêt (méthode plus robuste)
until pg_isready -U postgres -h localhost; do
  sleep 1
done

# Crée l'utilisateur et la base de données si nécessaire
if [ -n "$POSTGRES_USER" ] && [ -n "$POSTGRES_PASSWORD" ] && [ -n "$POSTGRES_DB" ]; then
    psql -U postgres -c "CREATE USER \"$POSTGRES_USER\" WITH PASSWORD '$POSTGRES_PASSWORD';"
    psql -U postgres -c "CREATE DATABASE \"$POSTGRES_DB\" OWNER \"$POSTGRES_USER\";"
fi

# Arrête PostgreSQL pour le redémarrer en foreground
kill $PID
wait $PID

# Démarre PostgreSQL en foreground
exec /usr/lib/postgresql/18/bin/postgres -D /var/lib/postgresql/18/main

