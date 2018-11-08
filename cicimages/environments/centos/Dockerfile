FROM centos/systemd
RUN yum update -q -y
RUN yum -y -q install vim openssh-server openssh-clients

RUN mkdir /root/.ssh
ADD ../../resources/keys/id_rsa* /root/.ssh/
RUN chmod 0600 /root/.ssh/id_rsa*
RUN cat ~/.ssh/id_rsa.pub > ~/.ssh/authorized_keys
RUN echo "Host *\n\tStrictHostKeyChecking no\n\tUserKnownHostsFile /dev/null" > ~/.ssh/config