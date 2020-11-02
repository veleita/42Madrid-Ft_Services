FROM	alpine:3.12

LABEL maintainer="María Zomeño https://github.com/veleita"

RUN 	apk update && \
		apk add libc6-compat && \
		wget https://dl.influxdata.com/telegraf/releases/telegraf-1.15.2_linux_amd64.tar.gz && \
		tar -xzf telegraf-1.15.2_linux_amd64.tar.gz && \
		cp -rf /telegraf-1.15.2/etc/*	/etc/ && \
		cp -rf /telegraf-1.15.2/usr/bin/*	/usr/bin/ && \
		cp -rf /telegraf-1.15.2/usr/lib/*	/usr/lib/ && \
		cp -rf /telegraf-1.15.2/var/log/*	/var/log/ && \
		rm -rf telegraf-1.15.2_linux_amd64.tar.gz && \
		rm -rf telegraf-1.15.2

WORKDIR	/usr/bin

#ENTRYPOINT	["./telegraf"]
#CMD ["--config", "/etc/telegraf/telegraf.conf"]
