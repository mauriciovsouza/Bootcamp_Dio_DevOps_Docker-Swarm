#!/bin/bash

#Instalar docker
echo "Instalando o Docker......."

curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Lê o token
TOKEN=$(cat /vagrant_shared/token.txt)

# Fazer o join
sudo docker swarm join --token $TOKEN 192.168.0.20:2377
