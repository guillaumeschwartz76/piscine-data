#!/bin/bash

docker exec -it postgres psql -U gschwart -d piscineds -c "\copy items FROM '/tmp/csv/item/item.csv' DELIMITER ',' CSV HEADER;"