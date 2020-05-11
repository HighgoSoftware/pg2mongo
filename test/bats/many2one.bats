#!/usr/bin/env bats

load assertions.bash


@test "$test_label setup MULTIPLE SLOTS replication test" {
  # copy files to mongo
  run docker cp sh-mg/. pg2mongo_mongo_1:/
  run docker cp tc-mg/. pg2mongo_mongo_1:/
  assert_success

  # copy files to postgres
  run docker cp sh-pg/. pg2mongo_pg1_1:/
  run docker cp tc-pg/. pg2mongo_pg1_1:/
  assert_success

  # copy files to postgres
  run docker cp sh-pg/. pg2mongo_pg2_1:/
  run docker cp tc-pg/. pg2mongo_pg2_1:/
  assert_success

  # create slot
  run docker exec -it pg2mongo_mongo_1 bash /create_slot.sh pg2mongo_pg1_1 postgres 1
  assert_success
}

### TC001
@test "$test_label replicate multiple postgres servers" {
  # set up one slot to each postgres server
  run docker exec -it pg2mongo_mongo_1 bash /create_slot.sh pg2mongo_pg1_1 postgres 1
  run docker exec -it pg2mongo_mongo_1 bash /create_slot.sh pg2mongo_pg2_1 postgres 1

  # create table and insert data
  run docker exec -it pg2mongo_pg1_1 bash /psql.sh tc001-pg.txt
  assert_success

  # create table and insert data 
  run docker exec -it pg2mongo_pg2_1 bash /psql.sh tc001-pg.txt
  assert_success
 
  # check the replication results
  sleep 3;
  run docker exec -it pg2mongo_mongo_1 bash /mongo.sh tc001-mg.txt 
  assert_success
  assert_match "switched to db mycluster_postgres_pg2mongo_pg1_1_postgres_w2m_slot1"
  assert_match "a.*test"
  assert_match "switched to db mycluster_postgres_pg2mongo_pg2_1_postgres_w2m_slot1"
  assert_match "a.*test"
}

### TC002
@test "$test_label replicate multiple tables from one postgres" {
  # create two databases on one postgres server
  run docker exec -it pg2mongo_pg1_1 bash /psql.sh tc002-pg.txt
  assert_success

  # check the replication results
  sleep 3;
  run docker exec -it pg2mongo_mongo_1 bash /mongo.sh tc002-mg.txt
  assert_success
  assert_match "switched to db mycluster_postgres_pg2mongo_pg1_1_postgres_w2m_slot1"
  assert_match "a.*test-a"
  assert_match "b.*test-b"
}
 
### TC003
@test "$test_label replicate multiple tables from multiple postgres" {
  # create two tables on each postgres server
  run docker exec -it pg2mongo_pg1_1 bash /psql.sh tc002-pg.txt
  run docker exec -it pg2mongo_pg2_1 bash /psql.sh tc002-pg.txt
  assert_success

  # check the replication results
  sleep 3;
  run docker exec -it pg2mongo_mongo_1 bash /mongo.sh tc003-mg.txt teardown
  assert_success
  assert_match "switched to db mycluster_postgres_pg2mongo_pg1_1_postgres_w2m_slot1"
  assert_match "a.*test-a"
  assert_match "b.*test-b"
  assert_match "switched to db mycluster_postgres_pg2mongo_pg2_1_postgres_w2m_slot1"
  assert_match "a.*test-a"
  assert_match "b.*test-b"
}

### TC004
@test "$test_label replicate multiple databases from one postgres" {
  # create db1 and db2
  run docker exec -it pg2mongo_pg1_1 bash /psql.sh tc004-pg.txt
  assert_success

  # create one slot on each database
  run docker exec -it pg2mongo_mongo_1 bash /create_slot.sh pg2mongo_pg1_1 db1 1
  run docker exec -it pg2mongo_mongo_1 bash /create_slot.sh pg2mongo_pg1_1 db2 1
  assert_success

  # create table and insert data to each database
  run docker exec -it pg2mongo_pg1_1 bash /psql_dbs.sh tc004.1-pg.txt db1
  run docker exec -it pg2mongo_pg1_1 bash /psql_dbs.sh tc004.1-pg.txt db2
  assert_success

  # check the replication results
  sleep 3;
  run docker exec -it pg2mongo_mongo_1 bash /mongo.sh tc004-mg.txt teardown
  assert_success
  assert_match "switched to db mycluster_db1_pg2mongo_pg1_1_db1_w2m_slot1"
  assert_match "a.*test"
  assert_match "switched to db mycluster_db2_pg2mongo_pg1_1_db2_w2m_slot1"
  assert_match "a.*test"
}

### TC005
@test "$test_label replicate multiple databases from multiple postgres" {
  # create db1 and db2
  run docker exec -it pg2mongo_pg1_1 bash /psql.sh tc005-pg.txt
  assert_success

  # create db1 and db2
  run docker exec -it pg2mongo_pg2_1 bash /psql.sh tc005-pg.txt
  assert_success

  # create one slot on each database
  run docker exec -it pg2mongo_mongo_1 bash /create_slot.sh pg2mongo_pg1_1 db1 1
  run docker exec -it pg2mongo_mongo_1 bash /create_slot.sh pg2mongo_pg1_1 db2 1
  assert_success
  run docker exec -it pg2mongo_mongo_1 bash /create_slot.sh pg2mongo_pg2_1 db1 1
  run docker exec -it pg2mongo_mongo_1 bash /create_slot.sh pg2mongo_pg2_1 db2 1
  assert_success

  # create table and insert data to each database
  run docker exec -it pg2mongo_pg1_1 bash /psql_dbs.sh tc005.1-pg.txt db1
  run docker exec -it pg2mongo_pg1_1 bash /psql_dbs.sh tc005.1-pg.txt db2

  # create table and insert data to each database
  run docker exec -it pg2mongo_pg2_1 bash /psql_dbs.sh tc005.1-pg.txt db1
  run docker exec -it pg2mongo_pg2_1 bash /psql_dbs.sh tc005.1-pg.txt db2
 
  # check the replication results
  sleep 3;
  run docker exec -it pg2mongo_mongo_1 bash /mongo.sh tc005-mg.txt teardown
  assert_success
  assert_match "switched to db mycluster_db1_pg2mongo_pg1_1_db1_w2m_slot1"
  assert_match "a.*test"
  assert_match "switched to db mycluster_db2_pg2mongo_pg1_1_db2_w2m_slot1"
  assert_match "a.*test"
  assert_match "switched to db mycluster_db1_pg2mongo_pg2_1_db1_w2m_slot1"
  assert_match "a.*test"
  assert_match "switched to db mycluster_db2_pg2mongo_pg2_1_db2_w2m_slot1"
  assert_match "a.*test"
}
