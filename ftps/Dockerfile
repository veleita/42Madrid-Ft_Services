FROM	alpine:3.12

LABEL	maintainer="Maria Zomeño https://github.com/veleita"

ENV	\
FTPS_USER=ftps \
FTPS_PASSWORD=default

COPY	srcs/config.sh /tmp/config.sh

RUN 	apk update && \
		apk add openssl vsftpd && \
\
		addgroup -S ftps && \
		adduser -S -D -g ftps "$FTPS_USER" && \
		echo "$FTPS_USER":"$FTPS_PASSWORD" | chpasswd && \
\
		openssl req -x509 -newkey rsa:2048 -nodes \
		-subj "/C=SP/L=Madrid/O=42" \
		-keyout /etc/ssl/private/self_signed.key \
		-out /etc/ssl/certs/self_signed.crt && \
\
		tail -n 1 /etc/passwd >> /etc/vsftpd.chroot_list && \
		chmod +x /tmp/config.sh && sh /tmp/config.sh

EXPOSE	 21 32121

CMD 	/usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf
