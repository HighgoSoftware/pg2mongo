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

@test "$test_label BOOLEAN replication test" {
  # change data
  run docker exec -it pg2mongo_pg1_1 bash /psql.sh tc009-pg.txt
  assert_success
  
  # check replication results
  sleep 3;
  run docker exec -it pg2mongo_mongo_1 bash /mongo.sh tc009-mg.txt
  assert_success
  assert_match "a.*true"
}

@test "$test_label SMALLINT replication test" {
  # change data
  run docker exec -it pg2mongo_pg1_1 bash /psql.sh tc010-pg.txt
  assert_success
  
  # check replication results
  sleep 3;
  run docker exec -it pg2mongo_mongo_1 bash /mongo.sh tc010-mg.txt
  assert_success
  assert_match "a.*-32768"
}

@test "$test_label INTEGER replication test" {
  # change data
  run docker exec -it pg2mongo_pg1_1 bash /psql.sh tc011-pg.txt
  assert_success
  
  # check replication results
  sleep 3;
  run docker exec -it pg2mongo_mongo_1 bash /mongo.sh tc011-mg.txt
  assert_success
  assert_match "a.*-2147483648"
}

@test "$test_label SERIAL replication test" {
  # change data
  run docker exec -it pg2mongo_pg1_1 bash /psql.sh tc012-pg.txt
  assert_success
  
  # check replication results
  sleep 3;
  run docker exec -it pg2mongo_mongo_1 bash /mongo.sh tc012-mg.txt
  assert_success
  assert_match "a.*123456"
}

@test "$test_label REAL replication test" {
  # change data
  run docker exec -it pg2mongo_pg1_1 bash /psql.sh tc013-pg.txt
  assert_success
  
  # check replication results
  sleep 3;
  run docker exec -it pg2mongo_mongo_1 bash /mongo.sh tc013-mg.txt
  assert_success
  assert_match "a.*0.123456"
}

@test "$test_label BIGINT replication test" {
  # change data
  run docker exec -it pg2mongo_pg1_1 bash /psql.sh tc014-pg.txt
  assert_success
  
  # check replication results
  sleep 3;
  run docker exec -it pg2mongo_mongo_1 bash /mongo.sh tc014-mg.txt
  assert_success
  assert_match "a.*-9223372036854775808"
}

@test "$test_label BIGSERIAL replication test" {
  # change data
  run docker exec -it pg2mongo_pg1_1 bash /psql.sh tc015-pg.txt
  assert_success
  
  # check replication results
  sleep 3;
  run docker exec -it pg2mongo_mongo_1 bash /mongo.sh tc015-mg.txt
  assert_success
  assert_match "a.*1234567890"
}

@test "$test_label DOUBLE PRECISION replication test" {
  # change data
  run docker exec -it pg2mongo_pg1_1 bash /psql.sh tc016-pg.txt
  assert_success
  
  # check replication results
  sleep 3;
  run docker exec -it pg2mongo_mongo_1 bash /mongo.sh tc016-mg.txt
  assert_success
  assert_match "a.*-1.123456789123456"
}

@test "$test_label DECIMAL replication test" {
  # change data
  run docker exec -it pg2mongo_pg1_1 bash /psql.sh tc017-pg.txt
  assert_success
  
  # check replication results
  sleep 3;
  run docker exec -it pg2mongo_mongo_1 bash /mongo.sh tc017-mg.txt
  assert_success
  assert_match "a.*-1234567890.1234567891"
}

@test "$test_label NUMERIC replication test" {
  # change data
  run docker exec -it pg2mongo_pg1_1 bash /psql.sh tc018-pg.txt
  assert_success
  
  # check replication results
  sleep 3;
  run docker exec -it pg2mongo_mongo_1 bash /mongo.sh tc018-mg.txt
  assert_success
  assert_match "a.*-9876543210.0987654321"
}

@test "$test_label UUID replication test" {
  # change data
  run docker exec -it pg2mongo_pg1_1 bash /psql.sh tc019-pg.txt
  assert_success
  
  # check replication results
  sleep 3;
  run docker exec -it pg2mongo_mongo_1 bash /mongo.sh tc019-mg.txt
  assert_success
  assert_match "a.*a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11"
}

@test "$test_label BYTEA replication test" {
  # change data
  run docker exec -it pg2mongo_pg1_1 bash /psql.sh tc020-pg.txt
  assert_success
  
  # check replication results
  sleep 3;
  run docker exec -it pg2mongo_mongo_1 bash /mongo.sh tc020-mg.txt
  assert_success
  assert_match "a.*YWJjIDE1MzE1NDE1NSAwNTIyNTExMjQ="
}

@test "$test_label TIMESTAMPTZ replication test" {
  # change data
  run docker exec -it pg2mongo_pg1_1 bash /psql.sh tc021-pg.txt
  assert_success
  
  # check replication results
  sleep 3;
  run docker exec -it pg2mongo_mongo_1 bash /mongo.sh tc021-mg.txt
  assert_success
  assert_match "a.*2020-04-15T19:50:33Z"
}


