#!/bin/bash

set -m

PGDATA=/var/lib/highgo/hg-pgsql-12/data/db
CONFFILE=$PGDATA/PG_VERSION
export PATH=/usr/local/highgo/hg-pgsql/12/bin:$PATH

if [ -f "$CONFFILE" ]; then
	echo "$CONFFILE exist"
else
	initdb -D $PGDATA
	psql --command "CREATE USER wal2mongo WITH SUPERUSER PASSWORD 'wal2mongo';"
	createdb -O wal2mongo wal2mongo

	echo "listen_addresses='*'" >> $PGDATA/postgresql.conf
	echo "wal_level = logical"  >> $PGDATA/postgresql.conf
	echo "host  all  all  0.0.0.0/0  trust" >> $PGDATA/pg_hba.conf
fi

postgres -D $PGDATA
