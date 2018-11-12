FROM solita/ubuntu-systemd

RUN apt-get update -q -y

# USEFUL STUFF
RUN apt-get -y -q install vim curl bash unzip software-properties-common python-software-properties python3

#LATEST GIT
RUN apt-add-repository ppa:git-core/ppa
RUN apt-get clean && apt-get update && apt-get install -q -y git

# SSH KEYS
RUN mkdir -p /root/.ssh
ADD ./resources/keys/id_rsa* /root/.ssh/
RUN chmod 0600 /root/.ssh/id_rsa*
RUN cat ~/.ssh/id_rsa.pub > ~/.ssh/authorized_keys
RUN echo "Host *\n\tStrictHostKeyChecking no\n\tUserKnownHostsFile /dev/null" > ~/.ssh/config