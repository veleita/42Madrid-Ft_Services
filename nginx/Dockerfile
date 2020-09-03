FROM alpine:latest

LABEL maintainer="Maria Zomeño https://github.com/veleita/veleita"

# Install
COPY srcs/install.sh /tmp/install.sh
COPY srcs/nginx.conf /etc/nginx/nginx.conf
RUN sh /tmp/install.sh
COPY srcs/index.html /var/www/localhost/index.html
RUN chmod 644 /var/www/localhost/index.html

# Expose ports
EXPOSE 22 80 443

# Start ssh and run nginx
CMD nginx -g "daemon off;"
