FROM alpine:3.12

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
&& mkdir -p /var/www/wordpress/ \
&& cd /var/www/wordpress/ \
&& wget https://wordpress.org/latest.tar.gz \
&& tar -xzvf latest.tar.gz \
&& rm latest.tar.gz

COPY srcs/wp-config.php /var/www/wordpress/wp-config.php

CMD php -S 0.0.0.0:5050 -t /var/www/wordpress
