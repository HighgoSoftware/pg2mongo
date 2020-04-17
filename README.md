# pg2mongo
Replicate multiple PostgreSQL servers to a single MongoDB server using docker compose

#### Prerequisite
* Install Docker by refer to https://docs.docker.com/get-docker/
* (optional) psql (12.2) and mongo (4.2.5) need to be installed on local machine, if using them to connect containers from local mapping ports

### Setup with scripts
#### 1. clone repo
git clone https://github.com/HighgoSoftware/pg2mongo.git

#### 2. build images mongod:4.25 and postgres:12.2
```
cd pg2mongo
./build-images.sh
```

#### 3. start container and setup logical replication slots on `pg2mongo_mongo_1`
```
./start.sh 60
```

#### 4. generate databse traffic on containers `pg2mongo_pg1_1` and `pg2mongo_pg2_1`
```
$ docker exec -it pg2mongo_pg1_1 bash /data_gen.sh
$ docker exec -it pg2mongo_pg2_1 bash /data_gen.sh
```

#### 4. login `pg2mongo_mongo_1` to check data replicated
```
$ docker exec -it pg2mongo_mongo_1 bash
[root@a641d6c2cbb4 /]# mongo
> show dbs;
admin                         0.000GB
config                        0.000GB
local                         0.000GB
mycluster_postgres_w2m_slot1  0.005GB
mycluster_postgres_w2m_slot2  0.005GB
> use mycluster_postgres_w2m_slot1
switched to db mycluster_postgres_w2m_slot1
> show collections
pgbench_accounts
pgbench_branches
pgbench_tellers
> db.pgbench_accounts.count()
174973
> use mycluster_postgres_w2m_slot2
switched to db mycluster_postgres_w2m_slot2
> db.pgbench_accounts.count()
175191
```

#### 5. stop containers
```
./stop.sh
```

