FROM solita/ubuntu-systemd

RUN apt-get -y -q update && apt-get -y -q install curl build-essential bash wget unzip python python-dev ca-certificates vim openssh-server && apt-get clean
RUN curl https://bootstrap.pypa.io/get-pip.py | python -
RUN pip install ansible boto awscli pytest testinfra

# terraform
RUN wget https://releases.hashicorp.com/terraform/0.11.3/terraform_0.11.3_linux_amd64.zip
RUN unzip terraform_0.11.3_linux_amd64.zip
RUN mv terraform /usr/bin/

RUN systemctl enable ssh.service
RUN ssh-keygen -t rsa -N "" -f /root/.ssh/id_rsa && cat ~/.ssh/id_rsa.pub > ~/.ssh/authorized_keys
RUN echo "Host *\n\tStrictHostKeyChecking no" > ~/.ssh/config
