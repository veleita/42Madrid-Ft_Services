#!/bin/bash

# VARIABLES #
# --------- #

# Colors
turquoise=$'\e[38;5;73m'
violet=$'\e[38;5;147m'
yellow=$'\e[38;5;229m'
salmon=$'\e[38;5;209m'
white=$'\e[38;5;231m'
lilac=$'\e[38;5;183m'
green=$'\e[38;5;120m'
ocean=$'\e[38;5;24m'
blue=$'\e[38;5;44m'
pink=$'\e[38;5;218m'
grey=$'\e[38;5;103m'
red=$'\e[38;5;124m'

# Ensure USER variabe is set
[ -z "${USER}" ] && export USER=$(whoami)

# Paths
export INSTALL_PATH=/sgoinfre/students/$USER/bin/
export PATH=$PATH:$InstallPath
export MINIKUBE_HOME=/sgoinfre/students/$USER/
export SETUP_PATH=$(pwd)


#  VERBOSE  #
# --------- #

# A little presentation
echo "${white}Hey there! 👋" && sleep 0.5
echo "	Welcome to" && sleep 0.5
echo "		mzomeno-'s" && sleep 0.5
echo "${blue}			🚢FT_SERVICES🐳"
echo -n "		"
	for i in {1..30}; do sleep 0.02 && echo -n "-"; done
sleep 0.5 && echo ""

echo "${white}We are about to install the following set of services:"
echo "	=> ${red}FTPS${white}"
echo "	=> ${green}Nginx${white} with SSH"
echo "	=> ${blue}Wordpress${white} with Mariadb and phpmyadmin"
echo "	=> ${lilac}Influxdb${white} with Telegraf and Grafana"
echo "${white}into a ${turquoise}Kubernetes ${white}single-node cluster provided by ${turquoise}Minikube"
echo ""

read -n1 -p "${grey}[ Press ENTER to proceed ]" enter
echo ""

# Disclaimers
echo "⚠️  ${white}This project has only been tested on ${yellow}darwin18.0${white} and will be set up to run"
echo "on a 42Network environment."
echo ""
echo "📦 It will require you to have ${blue}Docker${white} and ${turquoise}VirtualBox${white} installed on your machine."
echo ""
echo "💿 Please make sure that you have enough free space on your disk (${salmon}around 2G${white}"
echo "should be fine) so that the installation completes correctly"
echo ""

read -n1 -p "${grey}[ Press ENTER to proceed ]" enter
echo ""


#   SETUP   #
# --------- #

# Installation
if [ ! -d /Applications/VirtualBox.app ] && \
	[ ! -d ~/Applications/VirtualBox.app ]; then
		echo " 👎 -- ${ocean}VirtualBox ${white} doesn't seem to be installed on your machine."
		echo "		 you can install it with ${salmon}MSC${white}"
		sleep 3
		open -a "Managed Software Center"
		exit 0
fi

./init_docker.sh	
#	if [ ! -d /Applications/Docker.app ] && \
#		[ ! -d ~/Applications/Docker.app ] && \
#		[ ! -d /goinfre/$USER/docker ]; then
#			echo " 👎 -- ${blue}Docker ${white}doesn't seem to be installed on your machine."
#			echo "		 you can install it with ${salmon}MSC${white}"
#			sleep 3
#			open -a "Managed Software Center"
#			exit 0
#	else
#			# Kill Docker if started, so it doesn't create files during the process
#			pkill Docker
#			open -g -a Docker && \
#			echo " 👍 -- ${blue}Docker ${white}starting!"
#			echo ""
#			sleep 10
#	fi

if [ ! -h /Users/$USER/.brew/bin/minikube ] && \
	[ ! -x /sgoinfre/students/$USER/*/minikube ]; then
	cd $INSTALL_PATH && \
	curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-darwin-amd64 && \
	chmod +x minikube && \
	echo "  👍 -- ${grey}Minikube${white} installed"
	echo ""
fi

if [ ! -h /Users/$USER/.brew/bin/kubectl ] && \
	[ ! -x /sgoinfre/students/$USER/*/kubectl ]; then
	cd $INSTALL_PATH
	curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/darwin/amd64/kubectl" && \
	chmod +x ./kubectl && \
	echo "  👍 -- ${turquoise}Kubectl${white} installed"
	echo ""
fi


## MINIKUBE
echo -e "${grey}Minikube"
for i in {1..28}; do sleep 0.02 && echo -n "-"; done
echo "${white}"

# Restart "42services" cluster on VirtualBox driver
minikube config set profile 42services
minikube config set driver virtualbox
minikube start

# Import Docker daemon to the cluster
#### ADD TO README [https://stackoverflow.com/questions/52310599/what-does-minikube-docker-env-mean]
eval $(minikube docker-env)

echo ""


# METALLB 
#### ADD TO README [https://metallb.universe.tf]
#-------------------------------------------------------
echo -e "${green}MetalLB${white}"
for i in {1..28}; do sleep 0.02 && echo -n "-"; done
sleep 1 && echo "${white}"

kubectl get configmap kube-proxy -n kube-system -o yaml | \
sed -e "s/strictARP: false/strictARP: true/" | \
kubectl apply -f - -n kube-system 2> /dev/null

kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/metallb.yaml
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
kubectl apply -f srcs/metallb/config.yaml

echo ""


## DOCKER
echo -e "${blue}Docker containers"
for i in {1..28}; do sleep 0.02 && echo -n "-"; done
sleep 1 && echo "${white}"
docker build -t mzomeno-nginx srcs/nginx/
docker build -t mzomeno-mysql srcs/mysql/
docker build -t mzomeno-ftps srcs/ftps/
docker build -t mzomeno-wordpress srcs/wordpress/
docker build -t mzomeno-phpmyadmin srcs/phpmyadmin/


## KUBERNETES
echo -e "${turquoise}Kubernetes objects"
for i in {1..28}; do sleep 0.02 && echo -n "-"; done
sleep 1 && echo "${white}"
kubectl apply -f srcs/nginx/nginx.yaml
kubectl apply -f srcs/mysql/mysql.yaml
kubectl apply -f srcs/ftps/ftps.yaml
kubectl apply -f srcs/phpmyadmin/phpmyadmin.yaml
kubectl apply -f srcs/wordpress/wordpress.yaml
#kubectl apply -f ../services/grafana/grafana.yaml
#kubectl apply -f ../services/influxdb/influxdb.yaml
#kubectl apply -f ../services/telegraf/telegraf.yaml


## FINISH
minikube ip
kubectl get svc
minikube delete 2> /dev/null
