#!/bin/bash
set -m

MYPATH=`pwd`

### build centos7 base docker images
cd $MYPATH/centos7-base
docker build -t centos7-base . -f Dockerfile

### build postgres docker images
cd $MYPATH/postgres
docker build -t postgres:12 . -f Dockerfile

### build mongod docker images
cd $MYPATH/mongod
docker build -t mongod:4.2.5 . -f Dockerfile
