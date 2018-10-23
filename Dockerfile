FROM solita/ubuntu-systemd



RUN apt-get -y -q update && apt-get -y install software-properties-common python-software-properties
RUN apt-add-repository ppa:git-core/ppa
RUN apt-get -y -q install checkinstall tk-dev libgdbm-dev libncursesw5-dev libreadline-gplv2-dev libsqlite3-dev curl build-essential libbz2-dev libc6-dev bash wget unzip ca-certificates vim openssh-server openssl libffi-dev libssl-dev python3-dev python3-setuptools zlib1g-dev git chromium-browser netcat && apt-get clean



RUN git clone https://github.com/pyenv/pyenv.git ~/.pyenv && echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc && echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc && echo 'eval "$(pyenv init -)"' >> ~/.bashrc

RUN ["/bin/bash", "-c", "PYENV_ROOT=\"$HOME/.pyenv\" && export PATH=\"$PYENV_ROOT/bin:$PATH\" && eval \"$(pyenv init -)\" && pyenv install 3.7.0 && pyenv global 3.7.0 && pip install ansible pytest testinfra pylint"]

RUN systemctl enable ssh.service
RUN ssh-keygen -t rsa -N "" -f /root/.ssh/id_rsa && cat ~/.ssh/id_rsa.pub > ~/.ssh/authorized_keys
RUN echo "Host *\n\tStrictHostKeyChecking no\n\tUserKnownHostsFile /dev/null" > ~/.ssh/config

RUN curl -fsSL https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-installer | bash; exit 0

ENV PATH "/root/.rbenv/bin:$PATH"
RUN echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> /root/.bashrc
RUN echo 'eval "$(rbenv init -)"' >> /root/.bashrc
RUN bash -c "rbenv install 2.4.3 && rbenv global 2.4.3"

RUN curl -sSL https://get.docker.com/ | sh
RUN curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose

ADD ./bin /cic/bin
ADD ./.cic /cic/.cic
ADD .courseware* /cic/
ADD Gemfile* /cic/

WORKDIR '/cic'

RUN apt-get clean && apt-get update && apt-get -y upgrade git
RUN mkdir /etc/ansible && echo "[localhost]\n127.0.0.1  ansible_connection=local" > /etc/ansible/hosts
RUN ["/bin/bash", "-c", "eval \"$(rbenv init -)\" && gem install bundler && bundle install"]