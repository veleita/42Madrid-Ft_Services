FROM alpine:3.12

COPY srcs/wp-config.php /var/www/localhost/wordpress/wp-config.php

EXPOSE 5050

RUN apk update \
&& apk add \
php7 \
php7-common \
php7-fpm \
php7-json \
php7-opcache \
php7-mysqli \
php7-mbstring \
&& mkdir -p /usr/share/webapps/ \
&& cd /usr/share/webapps/ \
&& wget https://wordpress.org/latest.tar.gz \
&& tar -xzvf latest.tar.gz \
&& rm latest.tar.gz \
&& ln -s /usr/share/webapps/wordpress/ /var/www/localhost/wordpress/
