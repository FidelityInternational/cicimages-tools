FROM cicimages/wrappers-python
RUN ["/bin/bash", "-ic", "pip install ansible"]

RUN mkdir /etc/ansible && echo "[localhost]\n127.0.0.1  ansible_connection=local" > /etc/ansible/hosts