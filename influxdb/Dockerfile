FROM alpine:3.12

# This is just a signature
LABEL	maintainer="Maria Zomeño https://github.com/veleita"

RUN apk add influxdb

CMD influxd run -config /etc/influxdb.conf
