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
RUN echo 'eval "$(rbenv init -)"' >> /root/.bashrc
RUN bash -c "rbenv install 2.4.3 && rbenv global 2.4.3"

# DOCKER
RUN curl -sSL https://get.docker.com/ | sh
RUN curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose

# TOOLING
ADD ./bin /cic/bin
ADD ./.cic /cic/.cic
ADD Gemfile* /cic/

WORKDIR '/cic'
RUN ["/bin/bash", "-c", "eval \"$(rbenv init -)\" && gem install bundler && bundle install"]

