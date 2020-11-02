FROM	alpine:3.12

LABEL	maintainer="María Zomeño https://github.com/veleita"

RUN 	apk update && \
		apk add mariadb mariadb-client

EXPOSE 	3306

CMD 	mariadb-install-db --user=root --datadir=/data && \
		mariadbd-safe --user=root --datadir=/data
