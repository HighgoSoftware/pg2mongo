#!/bin/bash

set -m

if [[ "$1" == "-h" ]]; then
	echo "Usage:"
	echo "  * Outside of the container:"
	echo -e "\tdocker exec -it pg2mongo_pg2_1 bash /data_gen.sh"
	echo "  * Inside of the container:"
	echo -e "\t./`basename $0`"
	echo "  where 'pg2mongo_pg2_1' is the running  postgres container"
	exit 0
fi

source /var/lib/pgsql/.bashrc
pgbench -i -p 5432 -d postgres
status=$?
if [ $status -ne 0 ]; then
	echo "Failed to start pgbench on: $status"
fi
sleep 1;

exit 0

