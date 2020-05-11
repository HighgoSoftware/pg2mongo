#!/bin/bash
set -m

docker-compose -f service-compose.yml up -d

if [[ $# -ne 0 && $1 -ge 30 ]]; then
	echo "Wait $1 sec for database startup ..."
	sleep $1;
	docker exec -it pg2mongo_mongo_1 bash /p2m.sh 1 2
	echo -e "\nPostgres to MongoDB logical replication slots setup is done\n"
fi
