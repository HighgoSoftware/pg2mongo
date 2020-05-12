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

@test "$test_label ARRAY BOOLEAN replication test" {
  # change data
  run docker exec -it pg2mongo_pg1_1 bash /psql.sh tc026-pg.txt
  assert_success
  
  # check replication results
  sleep 3;
  run docker exec -it pg2mongo_mongo_1 bash /mongo.sh tc026-mg.txt
  assert_success
  assert_match "a.*true"
}

@test "$test_label ARRAY BYTEA replication test" {
  # change data
  run docker exec -it pg2mongo_pg1_1 bash /psql.sh tc027-pg.txt
  assert_success
  
  # check replication results
  sleep 3;
  run docker exec -it pg2mongo_mongo_1 bash /mongo.sh tc027-mg.txt
  assert_success
  assert_match "a.*[HexData(0,\"deadbeef\")"
}

@test "$test_label ARRAY CHAR replication test" {
  # change data
  run docker exec -it pg2mongo_pg1_1 bash /psql.sh tc028-pg.txt
  assert_success
  
  # check replication results
  sleep 3;
  run docker exec -it pg2mongo_mongo_1 bash /mongo.sh tc028-mg.txt
  assert_success
  assert_match "a.*[\"c\",\"h\"])"
}

@test "$test_label ARRAY NAME replication test" {
  # change data
  run docker exec -it pg2mongo_pg1_1 bash /psql.sh tc029-pg.txt
  assert_success
  
  # check replication results
  sleep 3;
  run docker exec -it pg2mongo_mongo_1 bash /mongo.sh tc029-mg.txt
  assert_success
  assert_match "a.*[ \"teacher\", \"student\" ]"
}

@test "$test_label ARRAY INT2 replication test" {
  # change data
  run docker exec -it pg2mongo_pg1_1 bash /psql.sh tc030-pg.txt
  assert_success
  
  # check replication results
  sleep 3;
  run docker exec -it pg2mongo_mongo_1 bash /mongo.sh tc030-mg.txt
  assert_success
  assert_match "a.*[ 123, 456 ]"
}

@test "$test_label ARRAY INT4 replication test" {
  # change data
  run docker exec -it pg2mongo_pg1_1 bash /psql.sh tc031-pg.txt
  assert_success
  
  # check replication results
  sleep 3;
  run docker exec -it pg2mongo_mongo_1 bash /mongo.sh tc031-mg.txt
  assert_success
  assert_match "a.*[ 123456789, 987654321 ]"
}

@test "$test_label ARRAY TEXT replication test" {
  # change data
  run docker exec -it pg2mongo_pg1_1 bash /psql.sh tc032-pg.txt
  assert_success
  
  # check replication results
  sleep 3;
  run docker exec -it pg2mongo_mongo_1 bash /mongo.sh tc032-mg.txt
  assert_success
  assert_match "a.*[ \"abc\", \"123\" ]"
}

@test "$test_label ARRAY VARCHAR replication test" {
  # change data
  run docker exec -it pg2mongo_pg1_1 bash /psql.sh tc033-pg.txt
  assert_success
  
  # check replication results
  sleep 3;
  run docker exec -it pg2mongo_mongo_1 bash /mongo.sh tc033-mg.txt
  assert_success
  assert_match "a.*[ \"ABCD\", \"1234\" ]"
}

@test "$test_label ARRAY INT8 replication test" {
  # change data
  run docker exec -it pg2mongo_pg1_1 bash /psql.sh tc034-pg.txt
  assert_success
  
  # check replication results
  sleep 3;
  run docker exec -it pg2mongo_mongo_1 bash /mongo.sh tc034-mg.txt
  assert_success
  assert_match "a.*[ NumberLong(\"112233445566778896\"), NumberLong(\"998877665544332160\") ]"
}

@test "$test_label ARRAY FLOAT4 replication test" {
  # change data
  run docker exec -it pg2mongo_pg1_1 bash /psql.sh tc035-pg.txt
  assert_success
  
  # check replication results
  sleep 3;
  run docker exec -it pg2mongo_mongo_1 bash /mongo.sh tc035-mg.txt
  assert_success
  assert_match "a.*[ 123.456, 2222.3333 ]"
}

@test "$test_label ARRAY FLOAT8 replication test" {
  # change data
  run docker exec -it pg2mongo_pg1_1 bash /psql.sh tc036-pg.txt
  assert_success
  
  # check replication results
  sleep 3;
  run docker exec -it pg2mongo_mongo_1 bash /mongo.sh tc036-mg.txt
  assert_success
  assert_match "a.*[ NumberDecimal(\"123456.123\"), NumberDecimal(\"654321.123\") ]"
}

@test "$test_label ARRAY TIMESTAMPTZ replication test" {
  # change data
  run docker exec -it pg2mongo_pg1_1 bash /psql.sh tc037-pg.txt
  assert_success
  
  # check replication results
  sleep 3;
  run docker exec -it pg2mongo_mongo_1 bash /mongo.sh tc037-mg.txt
  assert_success
  assert_match "a.*[ ISODate(\"2020-03-30T17:18:40.120Z\"), ISODate(\"2020-03-31T03:28:40.120Z\") ]"
}

@test "$test_label ARRAY NUMERIC replication test" {
  # change data
  run docker exec -it pg2mongo_pg1_1 bash /psql.sh tc038-pg.txt
  assert_success
  
  # check replication results
  sleep 3;
  run docker exec -it pg2mongo_mongo_1 bash /mongo.sh tc038-mg.txt
  assert_success
  assert_match "a.*[ NumberDecimal(\"123456789\"), NumberDecimal(\"987654321\") ]"
}

@test "$test_label ARRAY UUID replication test" {
  # change data
  run docker exec -it pg2mongo_pg1_1 bash /psql.sh tc039-pg.txt
  assert_success
  
  # check replication results
  sleep 3;
  run docker exec -it pg2mongo_mongo_1 bash /mongo.sh tc039-mg.txt
  assert_success
  assert_match "a.*[ UUID(\"40e6215d\-b5c6\-4896\-987c\-f30f3678f608\"), UUID(\"3f333df6\-90a4\-4fda\-8dd3\-9485d27cee36\") ]"
}

