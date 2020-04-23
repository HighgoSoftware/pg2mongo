#!/bin/bash

set -m

# Exit code
retval=0

if [[ "$1" == "-h" ]]; then
	echo "Usage:"
	echo "  * Outside of the container:"
	echo -e "\tdocker exec -it pg2mongo_pg2_1 bash /data_gen.sh"
	echo "  * Inside of the container:"
	echo -e "\t./`basename $0`"
	echo "  where 'pg2mongo_pg2_1' is the running  postgres container"
	exit 0
fi

source /var/lib/highgo/.bashrc
pgbench -i -p 5333 -d postgres -U highgo
retval=$?
if [ $retval -ne 0 ]; then
	echo "Failed to start pgbench on: $retval"
fi
sleep 1;

exit $retval

