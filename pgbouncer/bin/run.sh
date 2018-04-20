docker run -d -p 6432:6432 --link pg:pg \
       --network hoianwebapp_default \
       -e PG_PORT_5432_TCP_ADDR=172.18.0.6 \
       -e PG_PORT_5432_TCP_PORT=5432 \
       -e PG_ENV_POSTGRESQL_USER=postgres \
       -e PG_ENV_POSTGRESQL_POOL_MODE=transaction \
       mbentley/ubuntu-pgbouncer
