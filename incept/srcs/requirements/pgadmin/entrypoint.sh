#!/bin/bash
# 'set -e' arrête le script si une commande échoue
# 'set -u' arrête le script si une variable non définie est utilisée
set -euo pipefail

# 1. Valider que les variables d'environnement nécessaires sont définies
: "${PGADMIN_DEFAULT_EMAIL:?Erreur: PGADMIN_DEFAULT_EMAIL n'est pas définie}"
: "${PGADMIN_DEFAULT_PASSWORD:?Erreur: PGADMIN_DEFAULT_PASSWORD n'est pas définie}"

# 2. Assurer les bonnes permissions sur les volumes (important au premier lancement)
chown -R www-data:www-data /var/lib/pgadmin /var/log/pgadmin

# 3. Initialiser la base de données de configuration de pgAdmin
#    (uniquement si le fichier .db n'existe pas encore)
if [ ! -f /var/lib/pgadmin/pgadmin4.db ]; then
    echo "Première exécution : Initialisation de la base de données pgAdmin..."
    
    # Exécuter le script de configuration en mode non interactif
    # Nous lui fournissons (via printf) :
    # 1. L'email
    # 2. Le mot de passe
    # 3. La confirmation du mot de passe
    printf '%s\n%s\n%s\n' \
        "$PGADMIN_DEFAULT_EMAIL" \
        "$PGADMIN_DEFAULT_PASSWORD" \
        "$PGADMIN_DEFAULT_PASSWORD" | /usr/pgadmin4/bin/setup-web.sh --yes
    
    echo "Initialisation de pgAdmin terminée."
fi

# 4. Activer les modules et sites Apache
#    (|| true : ne pas échouer si c'est déjà activé)
a2enmod wsgi || true
a2ensite pgadmin4.conf || true
a2dissite 000-default.conf || true

# 5. Lancer Apache en avant-plan (mode "Docker")
#    'exec' remplace le processus bash par Apache (PID 1)
echo "Démarrage de pgAdmin (via Apache)..."
exec apache2ctl -D FOREGROUND