#!/usr/bin/env bats

load assertions.bash

@test "$test_label setup INSERT, UPDATE and DELETE replication test" {
  # copy files to mongo
  run docker cp sh-mg/. pg2mongo_mongo_1:/
  run docker cp tc-mg/. pg2mongo_mongo_1:/
  assert_success

  # copy files to postgres
  run docker cp sh-pg/. pg2mongo_pg1_1:/
  run docker cp tc-pg/. pg2mongo_pg1_1:/
  assert_success

  # create slot
  run docker exec -it pg2mongo_mongo_1 bash /create_slot.sh pg2mongo_pg1_1 postgres 1
  assert_success
}

@test "$test_label INSERT replication test" {
  # change data
  run docker exec -it pg2mongo_pg1_1 bash /psql.sh tc006-pg.txt
  assert_success
  
  # check replication results
  sleep 20;
  run docker exec -it pg2mongo_mongo_1 bash /mongo.sh tc006-mg.txt
  assert_success
  assert_match "9876"
}

@test "$test_label UPDATE replication test" {
  # change data
  run docker exec -it pg2mongo_pg1_1 bash /psql.sh tc007-pg.txt
  assert_success

  # check replication results
  sleep 40;
  run docker exec -it pg2mongo_mongo_1 bash /mongo.sh tc007-mg.txt
  assert_success
  assert_match "5432"
}

@test "$test_label DELETE replication test" {
  run docker exec -it pg2mongo_pg1_1 bash /psql.sh tc008-pg.txt
  assert_success

  # check the replication results
  sleep 40;
  run docker exec -it pg2mongo_mongo_1 bash /mongo.sh tc008-mg.txt
  assert_success
  assert_match "4321"
}

@test "$test_label PARTITIONED TABLE INSERT replication test" {
  # change data
  run docker exec -it pg2mongo_pg1_1 bash /psql.sh tc006.1-pg.txt
  assert_success
  
  # check replication results
  sleep 10;
  run docker exec -it pg2mongo_mongo_1 bash /mongo.sh tc006.1-mg.txt
  assert_success
  assert_match "9"
  assert_match "10"
  assert_match "21"
}

@test "$test_label PARTITIONED TABLE UPDATE replication test" {
  # change data
  run docker exec -it pg2mongo_pg1_1 bash /psql.sh tc007.1-pg.txt
  assert_success
  
  # check replication results
  sleep 10;
  run docker exec -it pg2mongo_mongo_1 bash /mongo.sh tc007.1-mg.txt
  assert_success
  assert_match "5"
  assert_match "5"
  assert_match "10"
}

@test "$test_label PARTITIONED TABLE DELETE replication test" {
  # change data
  run docker exec -it pg2mongo_pg1_1 bash /psql.sh tc008.1-pg.txt
  assert_success
  
  # check replication results
  sleep 10;
  run docker exec -it pg2mongo_mongo_1 bash /mongo.sh tc008.1-mg.txt
  assert_success
  assert_match "5"
  assert_match "5"
  assert_match "10"
}

