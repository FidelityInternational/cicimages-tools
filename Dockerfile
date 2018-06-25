FROM solita/ubuntu-systemd

RUN apt-get -y -q update && apt-get -y -q install curl build-essential bash wget unzip python python-dev ca-certificates vim openssh-server libssl-dev libreadline-dev zlib1g-dev git && apt-get clean

RUN curl https://bootstrap.pypa.io/get-pip.py | python -
RUN pip install ansible boto awscli pytest testinfra


RUN curl -fsSL https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-installer | bash; exit 0

ENV PATH "/root/.rbenv/bin:$PATH"
RUN bash -c "rbenv install 2.4.3"
RUN /bin/bash -c "rbenv global 2.4.3"
RUN ["/bin/bash", "-c", "eval \"$(rbenv init -)\" && gem install bundler"]

RUN curl -sSL https://get.docker.com/ | sh


# terraform
RUN wget https://releases.hashicorp.com/terraform/0.11.3/terraform_0.11.3_linux_amd64.zip
RUN unzip terraform_0.11.3_linux_amd64.zip
RUN mv terraform /usr/bin/

RUN systemctl enable ssh.service
RUN ssh-keygen -t rsa -N "" -f /root/.ssh/id_rsa && cat ~/.ssh/id_rsa.pub > ~/.ssh/authorized_keys
RUN echo "Host *\n\tStrictHostKeyChecking no" > ~/.ssh/config

ADD ./bin /cic/bin
ADD Gemfile* /cic/

WORKDIR '/cic'

RUN ["/bin/bash", "-c", "eval \"$(rbenv init -)\" && bundle install"]

RUN echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> /root/.bashrc
RUN echo 'eval "$(rbenv init -)"' >> /root/.bashrc


