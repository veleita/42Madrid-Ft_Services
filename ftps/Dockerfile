FROM alpine:3.12

LABEL maintainer="Maria Zomeño https://github.com/veleita"

COPY srcs/install.sh /tmp/install.sh
RUN chmod +x /tmp/install.sh && sh /tmp/install.sh

EXPOSE 21 32121 32122

CMD /usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf
