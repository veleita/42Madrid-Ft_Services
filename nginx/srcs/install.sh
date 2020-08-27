#!/bin/sh

# Install openssl, openssh, and nginx
apk update
apk add openssl openssh nginx --no-cache

# Create new user for the web server and add permissions
adduser -D "__NGINX_USER__"
mkdir /www
chown -R "__NGINX_USER__:__NGINX_USER__" /www /var/lib/nginx

# Create a new SSH user and password
adduser -D "__SSH_USER__"
echo "__SSH_USER__:__SSH_PASSWORD__" | chpasswd

# Generate SSH key
ssh-keygen -A

# Request SSL key
openssl req -newkey rsa:2048 -nodes -subj "/C=SP/L=Madrid/O=42" \
-keyout /etc/ssl/private/mzomeno-.key -out /etc/ssl/certs/mzomeno-.crt
