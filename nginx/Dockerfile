FROM alpine:latest

LABEL maintainer="Maria Zomeño https://github.com/veleita/veleita"

# Copy files to container
COPY srcs/install.sh /tmp/install.sh
COPY srcs/nginx.conf /etc/nginx/nginx.conf
COPY srcs/webpage.html /var/www/webpage.html

# Install
RUN sh /tmp/install.sh

# Expose ports
EXPOSE 20 80 443
