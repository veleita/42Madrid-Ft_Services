FROM alpine:3.12

LABEL maintainer="Maria Zomeño https://github.com/veleita"

# Install
COPY srcs/install.sh /tmp/install.sh
RUN chmod +x /tmp/install.sh && sh /tmp/install.sh

COPY srcs/nginx.conf /etc/nginx/nginx.conf

COPY srcs/index.html /var/www/localhost/index.html
RUN chmod 644 /var/www/localhost/index.html

# Expose ports
EXPOSE 22 80 443

# Start ssh and run nginx
CMD /usr/sbin/sshd; nginx -g "daemon off;"
