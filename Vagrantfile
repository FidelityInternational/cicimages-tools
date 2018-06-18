# -*- mode: ruby -*-
# vi: set ft=ruby :


Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/artful64"

  config.vm.provider "virtualbox" do |vb|
     vb.memory = "4096"
     vb.cpus = 4
  end

  config.vm.provision "shell",
    inline: "sudo groupadd docker; sudo usermod -aG docker vagrant"
end
