#!/bin/bash

# CUTE COLORS OMG
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

# PATHS
InstallPath=/sgoinfre/students/$USER/bin/

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
echo "	=> ${green}Nginx${white} with ${green}ssh${white}"
echo "	=> ${blue}Wordpress${white} with ${blue}Mariadb${white} and ${blue}phpmyadmin${white}"
echo "	=> ${lilac}Influxdb${white} with ${lilac}Telegraf${white} and ${lilac}Grafana"
echo "${white}into a ${turquoise}Kubernetes ${white}single-node cluster provided by ${grey}Minikube"
sleep 1 && echo ""

# Disclaimers
echo "⚠️  ${white}This project has only been testing on ${yellow}darwin18.0${white}"
echo ""
echo "It will require you to have ${blue}Docker${white} installed and running on your machine."
echo "Consider running the ${violet}init_docker ${white}script for this ${violet}in case you are on a"
echo "42Network environment${white}"
echo ""
echo "You will also need to have at least ${turquoise}Kubectl, ${ocean}VirtualBox ${white}and ${grey}Minikube"
echo "${white}installed on your machine."
echo "Consider running the ${violet}install_dependencies ${white}script for this ${violet}in case you are"
echo "on a 42Network environment${white}"
echo "" && sleep 1

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
	cd $InstallPath && \
	curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-darwin-amd64 && \
	chmod +x minikube && \
	echo "  👍 -- ${grey}Minikube${white} installed"
	echo ""
fi

if [ ! -h /Users/$USER/.brew/bin/kubectl ] && \
	[ ! -x /sgoinfre/students/$USER/*/kubectl ]; then
	cd $InstallPath
	curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/darwin/amd64/kubectl" && \
	chmod +x ./kubectl && \
	echo "  👍 -- ${turquoise}Kubectl${white} installed"
	echo ""
fi

####ADD SGOINFRE TO PATH!!

## MINIKUBE
#-------------------------------------------------------
echo -e "${grey}Minikube"
for i in {1..28}; do sleep 0.02 && echo -n "-"; done
echo "${white}"

# Delete minikube cluster in case it existed
minikube delete 2> /dev/null

# Start cluster
minikube start --driver=virtualbox

# Import Docker daemon to the cluster
#### ADD TO README [https://stackoverflow.com/questions/52310599/what-does-minikube-docker-env-mean]
eval $(minikube docker-env)

echo ""


# METALLB 
#### ADD TO README [https://metallb.universe.tf]
#-------------------------------------------------------
echo -e "${green}MetalLB${white}"
for i in {1..28}; do sleep 0.02 && echo -n "-"; done
sleep 0.3 && echo "${white}"

kubectl get configmap kube-proxy -n kube-system -o yaml | \
sed -e "s/strictARP: false/strictARP: true/" | \
kubectl apply -f - -n kube-system 2> /dev/null

kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/metallb.yaml
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
kubectl apply -f metallb/config.yaml
echo ""

echo -e "${blue}Docker Build"
for i in {1..28}; do sleep 0.02 && echo -n "-"; done
sleep 0.3 && echo "${white}"

echo "${green}Building NGINX image"
for i in {1..28}; do sleep 0.02 && echo -n "-"; done
echo "${white}"
docker build -t mzomeno-nginx nginx #&> /dev/null
echo ""
echo "${salmon}Building MYSQL image"
for i in {1..28}; do sleep 0.02 && echo -n "-"; done
echo "${white}"
docker build -t mzomeno-mysql mysql #&> /dev/null
echo ""
echo "${red}Building FTPS image"
for i in {1..28}; do sleep 0.02 && echo -n "-"; done
echo "${white}"
docker build -t mzomeno-ftps ftps #&> /dev/null
echo ""
echo "${ocean}Building PHPMYADMIN image"
for i in {1..28}; do sleep 0.02 && echo -n "-"; done
echo "${white}"
docker build -t mzomeno-phpmyadmin phpmyadmin #&> /dev/null
echo ""
echo "${blue}Building WORDPRESS image"
for i in {1..28}; do sleep 0.02 && echo -n "-"; done
echo "${white}"
docker build -t mzomeno-wordpress wordpress #&> /dev/null
echo ""
#docker build -t my-grafana srcs/grafana &> /dev/null
#docker build -t my-influxdb srcs/influxdb &> /dev/null
#docker build -t my-telegraf srcs/telegraf &> /dev/null
