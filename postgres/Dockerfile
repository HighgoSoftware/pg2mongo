FROM centos:centos7
MAINTAINER The CentOS Project <cloud-ops@centos.org>

RUN yum -y install https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm

RUN yum -y update; yum clean all
RUN yum -y install sudo epel-release yum-utils net-tools which; yum clean all

#RUN yum-config-manager --enable pgdg12
RUN yum -y install postgresql12-server postgresql12; yum clean all
RUN yum -y install git gcc make clang zlib-devel readline-devel postgresql12-devel; yum clean all

RUN echo 'root:root' | chpasswd
RUN echo 'postgres:postgres' | chpasswd
RUN usermod -aG wheel postgres
RUN echo "export PATH=/usr/pgsql-12/bin:$PATH" | tee -a /var/lib/pgsql/.bashrc
RUN echo "postgres ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/postgres && \
		chmod 0440 /etc/sudoers.d/postgres

USER postgres
COPY run.sh .
COPY build.sh .
RUN ./build.sh

VOLUME  ["/var/log/pgsql", "/var/lib/pgsql"]

EXPOSE 5432
CMD ["/run.sh"]
#CMD ["/usr/pgsql-12/bin/postgres", "-D", "/var/lib/pgsql/12/data"]
