# Most of what I've writen here is based on the nginx official DockerHub
# image for the 3.12 version of alpine, you can see the whole thing here
# https://github.com/nginxinc/docker-nginx/blob/5488180ebdd45b12b45107694dfa92dc878a2795/stable/alpine/Dockerfile
# Note that this version only works for x86_64 architectures, you can check
# your architecture in /etc/apk/arch
#------------------------------------------------------------------------------
FROM	alpine:3.12

# This is just a signature
LABEL	maintainer="Maria Zomeño https://github.com/veleita"

# Set environment variables, you can set them as docker run options (see Readme)
ENV		NGINX_VERSION	1.19.3
ENV		NJS_VERSION		0.4.4
ENV		PKG_RELEASE		1
ENV		SSH_PASSWORD	default

RUN \
# Create a system group called nginx with GID=101
		addgroup -S -g 101 nginx && \
# Create a system user called nginx with UID=101 /var/cache/nginx as home
# directory and include it in the nginx group
		adduser -S -u 101 -D -H -h /var/cache/nginx -g nginx nginx && \
\
# Install openssl using no cache into a virtual package called .cert-deps
		apk add --no-cache --virtual .cert-deps openssl && \
# Download nginx's public key from nginx.org and save it into /tmp/
		wget -O /tmp/nginx_signing.rsa.pub \
		https://nginx.org/keys/nginx_signing.rsa.pub && \
# Save openssl's rsa512 value into a variable
		KEY_SHA512="e7fa8303923d9b95db37a77ad46c68fd4755ff935d0a534d26eba83de13c76166c68bfe7f65471bf8881004ef4aa6df3e34689c305662750c0172fca5d8552a *stdin" && \
# Digest nginx's public key with sha512 and compare the output with the sha512
# value to validate the key
		if [ "$(openssl rsa -pubin -in /tmp/nginx_signing.rsa.pub -text -noout | openssl sha512 -r)" = "$KEY_SHA512" ]; then && \
			echo "Key verification succeeded!"; \
			mv /tmp/nginx_signing.rsa.pub /etc/apk/keys/; \
		else \
			echo "Key verification failed, generating new keys"; \
			openssl req -x509 -days 365 -newkey rsa:2048 -nodes \
# The -subj flag lets you add information about your key, you can edit those
# values at your convenience (C=country/L=City/O=Organization)
			-subj "/C=SP/L=Madrid/O=42" \
			-keyout /etc/ssl/keys/self_generated.key \
			-out /etc/ssl/certs/self_generated.crt ;\
		fi && \
# Now that we have our key, we can throw openssl to hell
		apk del .cert-deps && \
\
# Save package versions in a variable
		PackageVersions=" \
			nginx=${NGINX_VERSION}-r${PKG_RELEASE} \
			nginx-module-xslt=${NGINX_VERSION}-r${PKG_RELEASE} \
			nginx-module-geoip=${NGINX_VERSION}-r${PKG_RELEASE} \
			nginx-module-image-filter=${NGINX_VERSION}-r${PKG_RELEASE} \
			nginx-module-njs=${NGINX_VERSION}.${NJS_VERSION}-r${PKG_RELEASE} \
			" && \
		apk add -X "https://nginx.org/packages/mainline/alpine/v$(egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release)/main" --no-cache $PackageVersions && \
# Bring in tzdata so users could set the timezones through the environment
# variables
		apk add --no-cache tzdata && \
# Bring in curl and ca-certificates to make registering on DNS SD easier
		apk add --no-cache curl ca-certificates && \
# Forward request and error logs to docker log collector
		ln -sf /dev/stdout /var/log/nginx/access.log && \
		ln -sf /dev/stderr /var/log/nginx/error.log && \
\
# Create a new SSH user and password
		adduser -D "ssh" && \
		echo "ssh":"$SSH_PASSWORD" | chpasswd && \
# Generate SSH key
		ssh-keygen -A

# Copy our already edited configuration file into the nginx folder
COPY srcs/nginx.conf /etc/nginx/nginx.conf
# Copy our page's html index into our web directory for localhost
COPY srcs/index.html /var/www/localhost/index.html
# Let everyone read the index but restrict writing to nginx user
RUN chmod 644 /var/www/localhost/index.html

# Expose ports
EXPOSE 22 80 443

# Start ssh and run nginx
CMD /usr/sbin/sshd; nginx -g "daemon off;"
