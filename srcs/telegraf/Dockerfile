FROM	alpine:3.12

LABEL maintainer="María Zomeño https://github.com/veleita"

RUN 	apk update && \
		apk add libc6-compat bash && \
		wget https://dl.influxdata.com/telegraf/releases/telegraf-1.15.2_linux_amd64.tar.gz && \
		tar -xzf telegraf-1.15.2_linux_amd64.tar.gz && \
		rm -rf telegraf-1.15.2_linux_amd64.tar.gz /telegraf-1.15.2/etc/telegraf/telegraf.conf

COPY	srcs/telegraf.conf /telegraf-1.15.2/etc/telegraf/telegraf.conf
WORKDIR	/telegraf-1.15.2/usr/bin

ENTRYPOINT	["./telegraf"]
CMD ["--config", "/telegraf-1.15.2/etc/telegraf/telegraf.conf"]
