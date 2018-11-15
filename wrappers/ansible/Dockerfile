FROM cicimages/wrappers-python:latest
RUN ["/bin/bash", "-ic", "pip install ansible"]

RUN mkdir /etc/ansible && echo "[localhost]\n127.0.0.1  ansible_connection=local" > /etc/ansible/hosts

# TODO REMOVE ONCE all exercises are using cic up and cicimages/environments-ubuntu
RUN apt-get install -q -y openssh-server rsync