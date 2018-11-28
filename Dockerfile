FROM cicimages/base:latest

RUN apt-get install -q -y bzip2

# TODO REMOVE ONCE all exercises are using cic up and cicimages/environments-ubuntu
RUN apt-get install -q -y openssh-server
RUN apt-get install -q -y chromium-browser

#LATEST GIT
RUN apt-add-repository ppa:git-core/ppa
RUN apt-get clean && apt-get update && apt-get -y upgrade git

# RUBY
RUN curl -fsSL https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-installer | bash; exit 0

ENV PATH "/root/.rbenv/bin:$PATH"
RUN echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> /root/.bashrc
RUN bash -c "rbenv install 2.4.3 && rbenv global 2.4.3"

# DOCKER
RUN curl -sSL https://get.docker.com/ | sh
RUN curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose

# TOOLING
ADD support/bin /cic/bin
RUN echo 'export PATH="/cic/bin:$PATH"' >> /root/.bashrc
ADD pkg /mnt/gems
RUN ["/bin/bash", "-ilc", "eval \"$(rbenv init -)\" && gem install /mnt/gems/cic-tools-0.0.6.gem --no-ri --no-rdoc"]

WORKDIR '/cic'

