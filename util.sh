#!/bin/bash

echo "import csv fichiers customer"


docker exec -it postgres psql -U gschwart -d piscineds -c "\copy data_2022_dec FROM '/tmp/csv/customer/data_2022_dec.csv' DELIMITER ',' CSV HEADER;"
docker exec -it postgres psql -U gschwart -d piscineds -c "\copy data_2022_oct FROM '/tmp/csv/customer/data_2022_oct.csv' DELIMITER ',' CSV HEADER;"
docker exec -it postgres psql -U gschwart -d piscineds -c "\copy data_2022_nov FROM '/tmp/csv/customer/data_2022_nov.csv' DELIMITER ',' CSV HEADER;"
docker exec -it postgres psql -U gschwart -d piscineds -c "\copy data_2023_jan FROM '/tmp/csv/customer/data_2023_jan.csv' DELIMITER ',' CSV HEADER;"