FROM alpine:latest AS build

RUN apk --update add git python py-pip build-base automake libtool m4 autoconf libevent-dev openssl-dev c-ares-dev &&\
  pip install docutils &&\
  ln -s /usr/bin/rst2man.py /bin/rst2man

WORKDIR /opt/pgbouncer_src
RUN git clone --depth=1 --branch pgbouncer_1_8_1 https://github.com/pgbouncer/pgbouncer.git /opt/pgbouncer_src &&\
  git submodule init &&\
  git submodule update &&\
  mkdir -p /opt/pgbouncer &&\
  ./autogen.sh &&\
  ./configure --prefix=/opt/pgbouncer --with-libevent=/usr/lib  --with-pam=yes --with-openssl=yes&&\
  make &&\
  make install

FROM alpine:latest
RUN apk --update add libevent openssl c-ares perl
WORKDIR /
COPY --from=build /opt/pgbouncer /opt/pgbouncer
ADD ./config.ini.sample /etc/pgbouncer/config.ini.sample
ADD ./run.sh ./setup_configs.sh ./generate_config.pl /tmp/

ADD https://s3.amazonaws.com/rds-downloads/rds-combined-ca-bundle.pem /etc/pgbouncer/
RUN chown -R postgres:postgres /etc/pgbouncer

ENV POSTGRES_HOST 0.0.0.0
ENV POSTGRES_PORT 5432
ENV POSTGRES_DB postgres
ENV PGBOUNCER_LISTEN_HOST 0.0.0.0
ENV PGBOUNCER_LISTEN_PORT 6432
ENV PGBOUNCER_POOL_MODE transaction
ENV PGBOUNCER_MAX_CLIENT_CONN 10000
ENV PGBOUNCER_DEFAULT_POOL_SIZE 400
ENV PGBOUNCER_IDLE_TIMEOUT 240
ENV PGBOUNCER_USER pgbouncer
ENV PGBOUNCER_ADMIN_USERS pgbouncer
ENV PGBOUNCER_STAT_USERS pgbouncer
ENV PGBOUNCER_PASSWORD_MD5 md5

ENV TLS_ENABLE false
# ENV TLS_SSLMODE
# ENV TLS_CA_FILE

EXPOSE 6432
CMD /tmp/setup_configs.sh && /tmp/run.sh
