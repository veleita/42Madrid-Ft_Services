FROM 	alpine:3.12

LABEL 	maintainer="Maria Zomeño https://github.com/veleita"

EXPOSE 	5000

RUN		apk update \
		&& apk add phpmyadmin

COPY 	srcs/config.inc.php /usr/share/webapps/phpmyadmin/config.inc.php

CMD 	php -S 0.0.0.0:5000 -t /usr/share/webapps/phpmyadmin
