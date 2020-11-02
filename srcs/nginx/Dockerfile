# Most of what I've writen here is based on the nginx official DockerHub
# image for the 3.12 version of alpine, you can see the whole thing here
# https://github.com/nginxinc/docker-nginx/blob/5488180ebdd45b12b45107694dfa92dc878a2795/stable/alpine/Dockerfile
# Note that this version only works for x86_64 architectures, you can check
# your machine's architecture in /etc/apk/arch
#------------------------------------------------------------------------------
FROM	alpine:3.12

LABEL	maintainer="Maria Zomeño https://github.com/veleita"

ENV		NGINX_VERSION	1.19.3
ENV		NJS_VERSION		0.4.4
ENV		PKG_RELEASE		1
ENV		SSH_PASSWORD	default

RUN \
		addgroup -S -g 101 nginx && \
		adduser -S -u 101 -D -H -h /var/cache/nginx -g nginx nginx && \
\
		wget -O /etc/apk/keys/nginx_signing.rsa.pub https://nginx.org/keys/nginx_signing.rsa.pub && \
		PackageVersions=" \
			nginx=${NGINX_VERSION}-r${PKG_RELEASE} \
			nginx-module-xslt=${NGINX_VERSION}-r${PKG_RELEASE} \
			nginx-module-geoip=${NGINX_VERSION}-r${PKG_RELEASE} \
			nginx-module-image-filter=${NGINX_VERSION}-r${PKG_RELEASE} \
			nginx-module-njs=${NGINX_VERSION}.${NJS_VERSION}-r${PKG_RELEASE}" \
			&& \
		apk add -X "https://nginx.org/packages/mainline/alpine/v$(egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release)/main" --no-cache $PackageVersions && \
		mkdir -p /var/www /run/nginx /var/lib/nginx && \
		chown -R "nginx":"nginx" /var/www /run/nginx /var/lib/nginx && \
		chmod 755 /var/www /run/nginx /var/lib/nginx && \
\
		apk add --no-cache \
		openssh \
		openssl && \
		openssl req -x509 -days 30 -newkey rsa:2048 -nodes \
		-subj "/C=SP/L=Madrid/O=42" \
		-keyout /etc/ssl/private/self_signed.key \
		-out /etc/ssl/certs/self_signed.crt && \
\
		adduser -D "ssh" && \
		echo "ssh":"$SSH_PASSWORD" | chpasswd && \
		ssh-keygen -A

COPY 	srcs/nginx.conf /etc/nginx/nginx.conf
COPY	srcs/index.html /var/www/localhost/index.html

RUN		chmod 644 /var/www/localhost/index.html

EXPOSE	22 80 443

CMD		/usr/sbin/sshd; nginx -g "daemon off;"
