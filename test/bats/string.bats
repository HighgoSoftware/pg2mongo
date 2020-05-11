#!/usr/bin/env bats

load assertions.bash


@test "$test_label setup DATA TYPE replication test" {
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

@test "$test_label NETWORK replication test" {
  # change data
  run docker exec -it pg2mongo_pg1_1 bash /psql.sh tc022-pg.txt
  assert_success
  
  # check replication results
  sleep 3;
  run docker exec -it pg2mongo_mongo_1 bash /mongo.sh tc022-mg.txt
  assert_success
  assert_match "a.*192.168.100.128/25"
  assert_match "a.*2020:4f8:3:ba:2e0:81ff:fe22:d1f1/128"
}

@test "$test_label GEO replication test" {
  # change data
  run docker exec -it pg2mongo_pg1_1 bash /psql.sh tc023-pg.txt
  assert_success
  
  # check replication results
  sleep 3;
  run docker exec -it pg2mongo_mongo_1 bash /mongo.sh tc023-mg.txt
  assert_success
  assert_match "a.*(1,1)"
}

@test "$test_label JSON replication test" {
  # change data
  run docker exec -it pg2mongo_pg1_1 bash /psql.sh tc024-pg.txt
  assert_success
  
  # check replication results
  sleep 3;
  run docker exec -it pg2mongo_mongo_1 bash /mongo.sh tc024-mg.txt
  assert_success
  assert_match "a.*customer"
}

@test "$test_label XML replication test" {
  # change data
  run docker exec -it pg2mongo_pg1_1 bash /psql.sh tc025-pg.txt
  assert_success
  
  # check replication results
  sleep 3;
  run docker exec -it pg2mongo_mongo_1 bash /mongo.sh tc025-mg.txt
  assert_success
  assert_match "a.*<dept xmlns:smpl"
}

