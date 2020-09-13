#!/bin/sh

# Install openssl and vsftp
apk update
apk add openssl vsftpd

# Create new user for the server
addgroup ftps
adduser -D -g ftps mzomeno-
echo mzomeno-:ftpsswrd | chpasswd
tail -n 1 /etc/passwd >> /etc/vsftpd.chroot_list

# Request SSL key
openssl req -x509 -newkey rsa:2048 -nodes \
-subj "/C=SP/L=Madrid/O=42" \
-keyout /etc/ssl/private/mzomeno-.key \
-out /etc/ssl/certs/mzomeno-.crt

# Generate configuration file
mkdir -p /etc/vsftpd
cat <<EOF >> /etc/vsftpd/vsftpd.conf
seccomp_sandbox=NO
pasv_enable=YES
pasv_min_port=32121
pasv_max_port=32122
pasv_address=0.0.0.0
anonymous_enable=NO
local_enable=YES
write_enable=YES
allow_writeable_chroot=YES
chroot_list_enable=YES
chroot_list_file=/etc/vsftpd.chroot_list
local_umask=022
dirmessage_enable=YES
xferlog_enable=YES
connect_from_port_20=YES
ssl_enable=YES
rsa_cert_file=/etc/ssl/certs/mzomeno-.crt
rsa_private_key_file=/etc/ssl/private/mzomeno-.key
EOF
