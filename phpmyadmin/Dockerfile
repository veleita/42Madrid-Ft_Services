FROM alpine:3.12

LABEL maintainer="Maria Zomeño https://github.com/veleita"

RUN apk update \
&& apk add \
php7-common \
php7-iconv \
php7-json \
php7-gd \
php7-curl \
php7-xml \
php7-mysqli \
php7-imap \
php7-cgi \
fcgi \
php7-pdo \
php7-pdo_mysql \
php7-soap \
php7-xmlrpc \
php7-posix \
php7-mcrypt \
php7-gettext \
php7-ldap \
php7-ctype \
php7-dom \
&& mkdir -p /var/www/ \
&& cd /var/www/ \
&& wget http://files.directadmin.com/services/all/phpMyAdmin/phpMyAdmin-5.0.2-all-languages.tar.gz \
&& tar zxvf phpMyAdmin-5.0.2-all-languages.tar.gz \
&& rm phpMyAdmin-5.0.2-all-languages.tar.gz \
&& mv phpMyAdmin-5.0.2-all-languages phpmyadmin \
&& chmod -R 777 /var/www/

EXPOSE 5000

CMD php -S 0.0.0.0:5000 -t /var/www
