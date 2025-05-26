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
      master.vm.provision "shell", path: "shared/scripts/instalar-docker_master.sh"   
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