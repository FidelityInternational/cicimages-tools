FROM solita/ubuntu-systemd

RUN apt-get update -q -y

# USEFUL STUFF
RUN apt-get -y -q install vim curl bash unzip software-properties-common python-software-properties python3

# STUFF Required for installing programming runtimes
RUN apt-get -y -q install build-essential zlib1g-dev libffi-dev
RUN apt-get -y -q install libssl-dev
RUN apt-get -y -q install libsqlite3-dev libreadline-gplv2-dev libbz2-dev

# ALLOWS ansible to run on any server than inherits from this image
RUN apt-get -y -q install rsync

#LATEST GIT
RUN apt-add-repository ppa:git-core/ppa
RUN apt-get clean && apt-get update && apt-get install -q -y git

# SSH KEYS
RUN mkdir -p /root/.ssh
ADD ./resources/keys/id_rsa* /root/.ssh/
RUN chmod 0600 /root/.ssh/id_rsa*
RUN cat ~/.ssh/id_rsa.pub > ~/.ssh/authorized_keys
RUN echo "Host *\n\tStrictHostKeyChecking no\n\tUserKnownHostsFile /dev/null" > ~/.ssh/config