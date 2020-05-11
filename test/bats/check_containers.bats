#!/usr/bin/env bats

load assertions.bash

pg_image_name="postgres"
pg_image_tag="12"
@test "$test_label check image postgres:12" {
  run docker images
  assert_success
  assert_match "${pg_image_name}.*${pg_image_tag}"
}

@test "$test_label check image mongod:4.2.5" {
  run docker images
  assert_success
  assert_match "mongod.*4.2.5"
}

@test "$test_label check container pg2mongo_pg1_1" {
  run docker ps
  assert_success
  assert_match "pg2mongo_pg1_1"
}

@test "$test_label check container pg2mongo_pg2_1" {
  run docker ps
  assert_success
  assert_match "pg2mongo_pg2_1"
}

@test "$test_label check container pg2mongo_mongo_1" {
  run docker ps
  assert_success
  assert_match "pg2mongo_mongo_1"
}

@test "$test_label mongo show dbs" {
  # copy files to mongo
  run docker cp sh-mg/. pg2mongo_mongo_1:/
  run docker cp tc-mg/. pg2mongo_mongo_1:/
  assert_success

  run docker exec -it pg2mongo_mongo_1 bash /mongo.sh tc000-mg.txt
  assert_success
  assert_match "admin"
  assert_match "config"
  assert_match "local"
}

