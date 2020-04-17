#!/bin/bash

set -e

BLD_PATH=`pwd`

### build postgres docker images
cd $BLD_PATH/postgres
docker build -t postgres:12.2 . -f Dockerfile

### build mongod docker images
cd $BLD_PATH/mongod
docker build -t mongod:4.2.5 . -f Dockerfile
