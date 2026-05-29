#!/bin/bash
# 'set -e' arrête le script si une commande échoue
# 'set -u' arrête le script si une variable non définie est utilisée
set -euo pipefail

# 1. Valider que les variables d'environnement nécessaires sont définies
: "${PGADMIN_DEFAULT_EMAIL:?Erreur: PGADMIN_DEFAULT_EMAIL n'est pas définie}"
: "${PGADMIN_DEFAULT_PASSWORD:?Erreur: PGADMIN_DEFAULT_PASSWORD n'est pas définie}"

# 2. Assurer les bonnes permissions sur les volumes
chown -R www-data:www-data /var/lib/pgadmin /var/log/pgadmin

# =================================================================
# CONFIGURATION DE PGADMIN (Via son script officiel)
# =================================================================
echo "Configuration du serveur web pgAdmin..."
printf '%s\n%s\n%s\n' \
    "$PGADMIN_DEFAULT_EMAIL" \
    "$PGADMIN_DEFAULT_PASSWORD" \
    "$PGADMIN_DEFAULT_PASSWORD" | /usr/pgadmin4/bin/setup-web.sh --yes

# ... (après le script setup-web.sh)

echo "Importation du serveur Postgres..."
# On utilise le binaire python3 qui est DANS le venv de pgadmin
su -s /bin/bash -c "/usr/pgadmin4/venv/bin/python3 /usr/pgadmin4/web/setup.py load-servers /tmp/servers.json --user '$PGADMIN_DEFAULT_EMAIL'" www-data

# ... (puis lancement d'Apache)

# Message de débogage pour le premier lancement
if [ ! -f /var/lib/pgadmin/pgadmin4.db ]; then
    echo "Première exécution : Base de données pgAdmin initialisée."
fi

# =================================================================
# FIX APACHE & LANCEMENT
# =================================================================
# On désactive temporairement le mode strict '-u' pour éviter le crash
# lié aux variables internes d'Apache (/etc/apache2/envvars)
set +u

# Charger les variables d'environnement d'Apache
source /etc/apache2/envvars

# On réactive le mode strict par bonne pratique
set -u

# Lancer Apache au premier plan
echo "Démarrage d'Apache..."
exec apache2 -D FOREGROUND