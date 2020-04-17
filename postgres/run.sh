#!/bin/bash

set -x

DATAPATH=/var/lib/pgsql/12/data
CONFFILE=$DATAPATH/postgresql.conf
export PATH=/usr/pgsql-12/bin:$PATH

if [ -f "$CONFFILE" ]; then
		echo "$CONFFILE exist"
else
		initdb -D $DATAPATH
		psql --command "CREATE USER wal2mongo WITH SUPERUSER PASSWORD 'wal2mongo';" 
		createdb -O wal2mongo wal2mongo

		echo "listen_addresses='*'" >> $DATAPATH/postgresql.conf
		echo "wal_level = logical"  >> $DATAPATH/postgresql.conf
		echo "host  all  all  0.0.0.0/0  trust" >> $DATAPATH/pg_hba.conf
fi

postgres -D $DATAPATH 
