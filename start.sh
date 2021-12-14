#!/usr/bin/bash

# Docker instalation

# apt-get update && apt-get -y upgrade

if [ -x "$(command -v docker)" ]; then
    docker --version
else
    apt -y install apt-transport-https ca-certificates curl gnupg2 software-properties-common

    curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -

    add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/debian \
    $(lsb_release -cs) \
    stable"

    echo "deb [arch=amd64] https://download.docker.com/linux/debian buster stable" >> /etc/apt/sources.list

    apt update

    apt -y install docker-ce docker-ce-cli containerd.io

    sudo usermod -aG docker $USER

    docker --version
fi

if [ -x "$(command -v docker-compose)" ]; then
    docker-compose version
else

    echo "Docker compose instaltion..."

    curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

    chmod +x /usr/local/bin/docker-compose

    docker-compose version
fi


# launch docker services 

echo "Stop all containers"

docker stop $(docker ps -q)

# TODO: load env file

echo "Create the network"
docker network create traefik_net

echo "Start all docker-compose"

docker-compose -f traefik-docker-compose.yml up -d

docker-compose -f portainer-docker-compose.yml up -d

docker-compose -f bitwarden-docker-compose.yml up -d

docker-compose -f nextcloud-docker-compose.yml up -d
