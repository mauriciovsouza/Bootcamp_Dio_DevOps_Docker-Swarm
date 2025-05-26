### Automatizando a Criação de um Cluster Swarm com Vagrant e Máquinas Virtuais

Neste projeto, criei um `Vagrantfile` com as configurações necessárias para a criação de uma máquina master (que será o **manager**) e das demais máquinas como **workers**.

Para isso, utilizei dois scripts `.sh`:
- Um para a máquina **manager**, que inicializa o Swarm;
- Outro para adicionar as máquinas **workers** ao cluster.

Ambos os scripts também realizam a instalação do Docker automaticamente assim que as máquinas são criadas.

Outro ponto importante: no script `instalar-docker-master.sh`, o token gerado pelo Swarm é extraído automaticamente, permitindo que as máquinas **workers** sejam adicionadas ao cluster de forma automatizada e sem erros.

---

## Arquivos:

1. Vagrantfile:
   ```bash
      master = {
      "master" => {"memory" => "1024", "cpu" => "1", "image" => "bento/ubuntu-22.04", "ip" => "192.168.0.20"}
    }

    Vagrant.configure("2") do |config|

      master.each do |name, conf|
        config.vm.define "#{name}" do |master|
          master.vm.box = "#{conf["image"]}"
          master.vm.hostname = "#{name}"
          master.vm.network "public_network", ip: conf["ip"], bridge: "wlp4s0"
          master.vm.synced_folder "./shared", "/vagrant_shared"
          master.vm.provider "virtualbox" do |vb|
            vb.name = "#{name}"
            vb.memory = conf["memory"]
            vb.cpus = conf["cpu"]
            
          end
          master.vm.provision "shell", path: "shared/scripts/instalar-docker-master.sh"   
        end
      end
    end
    
    machines = {
      "node02" => {"memory" => "1024", "cpu" => "1", "image" => "bento/ubuntu-22.04", "ip" => "192.168.0.21"},
      "node03" => {"memory" => "1024", "cpu" => "1", "image" => "bento/ubuntu-22.04", "ip" => "192.168.0.22"},
      "node04" => {"memory" => "1024", "cpu" => "1", "image" => "bento/ubuntu-22.04", "ip" => "192.168.0.23"}
    }

    Vagrant.configure("2") do |config|

      machines.each do |name, conf|
        config.vm.define "#{name}" do |machine|
          machine.vm.box = "#{conf["image"]}"
          machine.vm.hostname = "#{name}"
          machine.vm.network "public_network", ip: conf["ip"], bridge: "wlp4s0"
          machine.vm.synced_folder "./shared", "/vagrant_shared"
          machine.vm.provider "virtualbox" do |vb|
            vb.name = "#{name}"
            vb.memory = conf["memory"]
            vb.cpus = conf["cpu"]
          end
          machine.vm.provision "shell", path: "shared/scripts/instalar-docker-vms.sh" 
        end
      end
    end
   ```

2. Script `instalar-docker-master.sh`
   ```bash
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

   ```

3. Script `instalar-docker-vms.sh`:
   ```bash
      #!/bin/bash

    #Instalar docker
    echo "Instalando o Docker......."

    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh

    # Lê o token
    TOKEN=$(cat /vagrant_shared/token.txt)

    # Fazer o join
    sudo docker swarm join --token $TOKEN 192.168.0.20:2377
   ```

---

Este projeto é parte do desafio proposto no Bootcamp da DIO  – **DevOps com Docker Swarm**.
