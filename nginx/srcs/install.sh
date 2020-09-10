#!/bin/sh

# Install openssl, openssh, and nginx
apk update
apk add openssl openssh nginx --no-cache

# Create new user for the web server and add permissions
adduser -D "$NGINX_USER"
mkdir -p /var/www /run/nginx
chown -R "$NGINX_USER":"$NGINX_USER" /var/www /run/nginx /var/lib/nginx
chmod 755 /var/www /run/nginx /var/lib/nginx

# Request SSL key
openssl req -x509 -newkey rsa:2048 -nodes \
-subj "/C=${COUNTRY}/L=${CITY}/O=${ORGANIZATION}" \
-keyout /etc/ssl/private/${NGINX_USER}.key \
-out /etc/ssl/certs/${NGINX_USER}.crt

# Create a new SSH user and password
adduser -D "$SSH_USER"
echo "$SSH_USER":"$SSH_PASSWORD" | chpasswd

# Generate SSH key
ssh-keygen -A
