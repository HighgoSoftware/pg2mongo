FROM centos7-base

### official RPM Repositories for CentOS 7 - x86_64 from Highgo
RUN yum -y install hg-pgsql12-server hg-pgsql12 hg-pgsql12-devel; yum clean all

RUN yum -y install git gcc make clang zlib-devel readline-devel; yum clean all

RUN usermod -aG wheel highgo
RUN echo "highgo ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/highgo && \
		chmod 0440 /etc/sudoers.d/highgo

USER highgo
RUN echo "export PATH=/usr/local/highgo/hg-pgsql/12/bin:$PATH" | tee -a /var/lib/highgo/.bashrc
COPY run.sh .
COPY build.sh .
RUN ./build.sh

VOLUME  ["/var/lib/highgo/hg-pgsql-12/data/log", "/var/lib/highgo/hg-pgsql-12"]
EXPOSE 5432
CMD ["/run.sh"]
