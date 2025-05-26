#!/bin/bash

echo "Instalando o Docker......."

curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Ativar o Swarm
echo "Ativando Docker Swarm......."
sudo docker swarm init --advertise-addr 192.168.0.20

# Captura o token de worker e salva em arquivo
WORKER_TOKEN=$(sudo docker swarm join-token worker -q)
echo $WORKER_TOKEN > /vagrant_shared/token.txt
