#!/bin/sh

# Install openssl and vsftp
apk update
apk add openssl vsftpd

# Create new user for the server
adduser -D "$FTPS_USER"
echo "$FTPS_USER":"$FTPS_PASSWORD" | chpasswd

# Request SSL key
openssl req -x509 -newkey rsa:2048 -nodes \
-subj "/C=${COUNTRY}/L=${CITY}/O=${ORGANIZATION}" \
-keyout /etc/ssl/private/${FTPS_USER}.key \
-out /etc/ssl/certs/${FTPS_USER}.crt

# Generate configuration file
mkdir -p /etc/vsftpd
cat <<EOF >> /etc/vsftpd/vsftpd.conf
seccomp_sandbox=NO
pasv_min_port=30020
pasv_max_port=30021
pasv_address=192.168.99.104
local_enable=YES
write_enable=YES
local_umask=022
dirmessage_enable=YES
xferlog_enable=YES
connect_from_port_20=YES
ssl_enable=YES
rsa_cert_file=/etc/ssl/certs/${FTPS_USER}.crt
rsa_private_key_file=/etc/ssl/private/${FTPS_USER}.key
EOF
