FROM solita/ubuntu-systemd

RUN apt-get -y -q update && apt-get -y -q install curl build-essential bash wget unzip python python-dev ca-certificates vim && apt-get clean
RUN curl https://bootstrap.pypa.io/get-pip.py | python -
RUN pip install ansible boto awscli

# terraform
RUN wget https://releases.hashicorp.com/terraform/0.11.3/terraform_0.11.3_linux_amd64.zip
RUN unzip terraform_0.11.3_linux_amd64.zip
RUN mv terraform /usr/bin/