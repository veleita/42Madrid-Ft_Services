#!/bin/sh

# Install openssl, openssh, and nginx
apk update
apk add openssl openssh nginx --no-cache

# Create new user for the web server and add permissions
adduser -D admin
mkdir -p /var/www /run/nginx
chown -R admin:admin /var/www /run/nginx /var/lib/nginx
chmod 755 /var/www /run/nginx /var/lib/nginx

# Request SSL key
openssl req -x509 -newkey rsa:2048 -nodes -subj "/C=SP/L=Madrid/O=42" -keyout /etc/ssl/private/admin.key -out /etc/ssl/certs/admin.crt

# Create a new SSH user and password
adduser -D mzomeno-
echo mzomeno-:psswd | chpasswd

# Generate SSH key
ssh-keygen -A
