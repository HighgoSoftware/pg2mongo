FROM centos:centos7
MAINTAINER Highgo Software Inc <david.zhang@highgo.ca>

### official RPM Repositories for CentOS 7 - x86_64 from Highgo
RUN yum -y install https://yum.highgo.ca/dists/rpms/repo/highgo-release-1.0-2.noarch.rpm

RUN yum -y update; yum clean all
RUN yum -y install sudo epel-release yum-utils net-tools which; yum clean all
