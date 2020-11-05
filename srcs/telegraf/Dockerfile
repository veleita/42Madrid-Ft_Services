FROM	alpine:3.12

LABEL maintainer="María Zomeño https://github.com/veleita"

RUN 	apk update && \
		apk add libc6-compat && \
		wget https://dl.influxdata.com/telegraf/releases/telegraf-1.15.2_linux_amd64.tar.gz && \
		tar -xzf telegraf-1.15.2_linux_amd64.tar.gz

COPY	srcs/telegraf.conf /telegraf-1.15.2/etc/telegraf.conf
WORKDIR	/usr/bin

ENTRYPOINT	["./telegraf"]
CMD ["--config", "/telegraf-1.15.2/etc/telegraf.conf"]
