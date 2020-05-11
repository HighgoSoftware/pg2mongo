#!/bin/bash
set -m

### usages: ./create_slot.sh container_name dbname num_of_slots
if [[ $# -ne 3 || "$1" == "-h" ]]; then
	echo "Usage:"
	echo "  * Outside of the container:"
	echo -e "\tdocker exec -it pg2mongo_mongo_1 bash /create_slot.sh container_name postgres 3"
	exit 0
fi

source /root/.bashrc
for i in $3
do
	rm -rf /tmp/pipe-$1-$2-${i}
	mkfifo /tmp/pipe-$1-$2-${i}
	sleep 1;

	pg_recvlogical -h $1 -d $2 -U postgres --slot $1_$2_w2m_slot${i} --create-slot --plugin=wal2mongo
	sleep 1;
	pg_recvlogical -h $1 -d $2 -U postgres --slot $1_$2_w2m_slot${i} --start -f /tmp/pipe-$1-$2-${i} &
	status=$?
	if [ $status -ne 0 ]; then
		echo "Failed to start pg_recvlogical: $status"
	fi

	mongo < /tmp/pipe-$1-$2-${i} &
	status=$?
	if [ $status -ne 0 ]; then
		echo "Failed to start mongo < /tmp/pipe-$1-$2-${i}: $status"
	fi
	sleep 1;
done
