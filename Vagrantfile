# -*- mode: ruby -*-
# vi: set ft=ruby :


Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/artful64"

  config.vm.provider "virtualbox" do |vb|
     vb.memory = "4096"
     vb.cpus = 4
  end

  config.vm.provision "shell", privileged: false, inline: <<-SHELL
    # install git
    sudo apt-get -y install git

    # install rbenv and ruby
    sudo apt-get -y install \
      autoconf bison build-essential libssl-dev libyaml-dev \
      libreadline6-dev zlib1g-dev libncurses5-dev \
      libffi-dev libgdbm3 libgdbm-dev
    git clone https://github.com/rbenv/rbenv.git ~/.rbenv
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
    echo 'eval "$(rbenv init -)"' >> ~/.bashrc
    export PATH="$HOME/.rbenv/bin:$PATH"
    git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
    rbenv install 2.4.3
    rbenv global 2.4.3
    eval "$(rbenv init -)"
    gem install bundler

    # install Docker
    sudo apt-get -y install \
      apt-transport-https \
      ca-certificates \
      curl \
      software-properties-common

    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

    sudo add-apt-repository -y \
      "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) \
      stable"

    sudo apt-get update
    sudo apt-get -y install docker-ce
    sudo usermod -aG docker vagrant
  SHELL
end
