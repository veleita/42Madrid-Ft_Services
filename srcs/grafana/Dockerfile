FROM	alpine:3.12

LABEL	maintainer="Maria Zomeño https://github.com/veleita"

RUN		apk update && \
		apk add --no-cache libc6-compat && \
		wget https://dl.grafana.com/oss/release/grafana-7.3.1.linux-amd64.tar.gz && \
		tar -zxvf grafana-7.3.1.linux-amd64.tar.gz && \
		rm grafana-7.3.1.linux-amd64.tar.gz

EXPOSE	3000

WORKDIR	/grafana-7.3.1/bin/

CMD		./grafana-server
