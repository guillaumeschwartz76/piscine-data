#!/bin/bash

echo "generate table begin"

# variable qui definie le chemin du repertoire
repertoire="/tmp/csv/customer"

# [] -d test l'existence d'un repertoire
if [ -d "$repertoire" ]
then
	echo "repertoir csv customer found"
else
	echo "repertoir csv customer not found: erreur"
fi

for fichier in $repertoire/*.csv
do
	filename=$(basename "$fichier")
	clean_name=${filename%%.*}

	#drop table supprime une table si elle existe deja.
	psql -d piscineds -c "DROP TABLE IF EXISTS \"$clean_name\";"

	psql -d piscineds -c "CREATE TABLE \"$clean_name\" (
	event_time TIMESTAMPTZ,
	event_type VARCHAR(50),
	product_id INTEGER,
	price NUMERIC(10,2),
	user_id BIGINT,
	user_session UUID
	);"

	psql -d piscineds -c "\COPY \"$clean_name\" FROM '$fichier' DELIMITER ',' CSV HEADER;"

	psql -d piscineds -c "GRANT ALL PRIVILEGES ON TABLE \"$clean_name\" TO \"gschwart\";"

	echo "$clean_name table create"
done
