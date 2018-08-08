FROM solita/ubuntu-systemd

RUN apt-get -y -q update && apt-get -y -q install curl build-essential bash wget unzip python python-dev ca-certificates vim openssh-server libssl-dev libreadline-dev zlib1g-dev git && apt-get clean

RUN systemctl enable ssh.service
RUN ssh-keygen -t rsa -N "" -f /root/.ssh/id_rsa && cat ~/.ssh/id_rsa.pub > ~/.ssh/authorized_keys
RUN echo "Host *\n\tStrictHostKeyChecking no\n\tUserKnownHostsFile /dev/null" > ~/.ssh/config

RUN curl https://bootstrap.pypa.io/get-pip.py | python -
RUN pip install ansible pytest testinfra


RUN curl -fsSL https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-installer | bash; exit 0

ENV PATH "/root/.rbenv/bin:$PATH"
RUN echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> /root/.bashrc
RUN echo 'eval "$(rbenv init -)"' >> /root/.bashrc
RUN bash -c "rbenv install 2.4.3 && rbenv global 2.4.3"

RUN curl -sSL https://get.docker.com/ | sh
RUN curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose

ADD ./bin /cic/bin
ADD .courseware* /cic/
ADD Gemfile* /cic/

WORKDIR '/cic'

RUN ["/bin/bash", "-c", "eval \"$(rbenv init -)\" && gem install bundler && bundle install"]