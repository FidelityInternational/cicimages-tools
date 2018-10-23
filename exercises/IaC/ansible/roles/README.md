## Introduction


Roles in Ansible are the way that related tasks and variables can be grouped together and shared. The choice of the word 'Role' comes from the idea that hosts are mapped to well defined roles.

In this exercise we will look at how Roles themselves are defined and imported within Ansible playbooks.

### Learning Objectives
- How to use Roles to DRY up playbooks by extracting tasks and removing duplication.

## Required prequisite knowledge
It is assumed that you know enough about Ansible to define a simple Platbook and define inventory to run it against.



**Note:** Before going any further do the following:
- `cd YOUR_CLONE_OF_THIS REPO`
- `source ./bin/env`
- `cd ./exercises/IaC/ansible/roles`

run `cic up` to bring up all the test infrastructure and support files required to complete this exercise. To stop and reset this infrastructure run ``

## Setting the Scene
The following playbook contains two plays. The first installs tomcat and the second installs [Eclipse Jetty](https://www.eclipse.org/jetty/), both of which are Java based web application containers. Both of the `jetty-server` and `tomcat-server` hosts referenced in the Playbook are real and can be connected to via the `cic connect` command. E.g. `cic connect tomcat-server`.

```YAML

---
ansible-playbook ansible/app_servers_automated.yaml -i ansible/inventory.yml
```

Write the above Playbook to `ansible/app_servers_automated.yaml` and run it with `ansible-playbook ansible/app_servers_automated.yaml -i ansible/inventory.yml`. If everything is working, you should see the following output:
```
PLAY [install tomcat] **********************************************************

TASK [Gathering Facts] *********************************************************
ok: [tomcat-server]

TASK [install java] ************************************************************
changed: [tomcat-server]

TASK [download tomcat] *********************************************************
changed: [tomcat-server]

TASK [create directory for tomcat installation] ********************************
changed: [tomcat-server]

TASK [unzip tomcat] ************************************************************
changed: [tomcat-server]

TASK [move files up one] *******************************************************
changed: [tomcat-server]

TASK [start tomcat] ************************************************************
changed: [tomcat-server]

PLAY [install jetty] ***********************************************************

TASK [Gathering Facts] *********************************************************
ok: [jetty-server]

TASK [install java] ************************************************************
changed: [jetty-server]

TASK [download jetty] **********************************************************
changed: [jetty-server]

TASK [create directory for jetty installation] *********************************
changed: [jetty-server]

TASK [unzip jetty] *************************************************************
changed: [jetty-server]

TASK [move files up one] *******************************************************
changed: [jetty-server]

TASK [start jetty] *************************************************************
changed: [jetty-server]

PLAY RECAP *********************************************************************
jetty-server               : ok=7    changed=6    unreachable=0    failed=0   
tomcat-server              : ok=7    changed=6    unreachable=0    failed=0   

[ OK ] FINISHED - start container with: cic start cic_container-xxxxxxxxxxxxxxxx
```

Visit [http://localhost:8080](http://localhost:8080) and [http://localhost:9090](http://localhost:8080) and you will see that both Tomcat and Jetty are both up and running.

Whilst the above playbook works it has a couple of issues:
- It's verbose which makes it difficult, at a glance, to tell what it does.
- There is a a lot of duplication, in fact the only difference between the two plays is the command required to start each of the servers.

## How to define a Role
**Note:** Before going any further run `cic down` and `cic up` to reset the cic test infrastructure.

The playbook we looked at earlier essentially gave the a role of application server to both the `tomcat-server` and `jetty-server` hosts. Therefore lets define a role called `application-server` that:

- Installs Java
- Downloads an archive containing the application server
- Unpacks the archive to the desired location
- Starts the server

Ansible automatically tries to find any role that you reference in a directory called `roles`. The `roles` directory should be local to the Playbook.

Let's start by by the creating the `roles` directory at `ansible/roles`, i.e. run "mkdir ansible/roles".


Each directory inside the `roles` directory represents a role. Therefore to create a role called `application-server` create the following directory `ansible/roles/application-server`.

### Role components
Within a role, if required, the following directories can be supplied:
- **tasks** - contains the main list of tasks to be executed by the role.
- **handlers** - contains handlers, which may be used by this role or even anywhere outside this role.
- **defaults** - default variables for the role (see Variables for more information).
- **vars** - other variables for the role (see Variables for more information).
- **files** - contains files which can be deployed via this role.
- **templates** - contains templates which can be deployed via this role.
- **meta** - defines meta data detailing things as dependencies

By default anything written in side a file called `main.yml` in any of these directories will automatically be picked up when the Role is loaded as part of a Playbook.



Studying our playbook we can see that if
- install location
- download url
- startup command

were supplied as variables, it would be possible to generify a set of tasks that could be extracted in to our `application-server` role. This means creating entries in the `tasks` and `vars` within our `application-server` role.

Starting with `vars`, move to the  `application-server` directory (`cd ansible/roles/application-server`) and make the `tasks` directory by running: `mkdir tasks`. Now write the following tasks to tasks/main.yml

```YAML
- name: install java
  apt:
    name: default-jdk
    state: latest

- name: download App Server
  get_url:
    url: "{{download_url}}"
    dest: "{{download_location}}"

- name: create directory for tomcat installation
  file:
    path: "{{installation_dir}}"
    state: directory
    mode: 0755

- name: unzip app server archive
  unarchive:
    src: "{{download_location}}"
    dest: "{{installation_dir}}"
    remote_src: yes

- name: move files up one
  command: bash -c 'cd {{installation_dir}} && dirname=$(ls) && mv "${dirname}"/* . && rm -R "${dirname}"'

- name: start app server
  command: bash -c 'cd {{installation_dir}} && {{start_command}}'

```

Due to defining these tasks within the `tasks` directory, we are only required to list the tasks themselves. There is no need to nest them underneath `tasks:` as is necessary when defining tasks within a Playbook.

In order to make these tasks reusable we have extracted the following variables:
- download_url
- download_location
- installation_dir
- start_command



Make a directory called by `vars` by running and `mkdir vars` and write the following variable declarations to `vars/main.yml`

```YAML
download_url:
start_command:

```



You'll notice that we haven't defined either `download_location` or `installation_dir`. This is because unless the user explicitly wants to set these they can be defaulted. Default variables are defined in the `defaults` directory. Create the `defaults` directory and write the following to `defaults/main.yml`.

```YAML
download_location: /tmp/server.download
installation_dir: /tmp/applicaton-server

```

---
- name: install tomcat
  hosts: tomcat-server
  roles:
  - { role: application-server,
      download_url: "http://mirrors.ukfast.co.uk/sites/ftp.apache.org/tomcat/tomcat-9/v9.0.12/bin/apache-tomcat-9.0.12.tar.gz",
      start_command: "nohup {{installation_dir}}/bin/startup.sh"
  }

- name: install jetty
  hosts: jetty-server
  roles:
  - { role: application-server,
      download_url: "https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-distribution/9.4.12.v20180830/jetty-distribution-9.4.12.v20180830.zip",
      start_command: "cd {{installation_dir}}/demo-base && nohup java -jar ../start.jar &"
  }


Now that the `application-server` role has been defined, we can use it within our playbook. Change directory back to the root of this exercise, i.e. `cd ../../../` and write the following to `ansible/app_servers_automated.yaml`

```YAML
---
- name: install tomcat
  hosts: tomcat-server
  roles:
  - { role: application-server,
      download_url: "http://mirrors.ukfast.co.uk/sites/ftp.apache.org/tomcat/tomcat-9/v9.0.12/bin/apache-tomcat-9.0.12.tar.gz",
      start_command: "nohup {{installation_dir}}/bin/startup.sh"
  }

- name: install jetty
  hosts: jetty-server
  roles:
  - { role: application-server,
      download_url: "https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-distribution/9.4.12.v20180830/jetty-distribution-9.4.12.v20180830.zip",
      start_command: "cd {{installation_dir}}/demo-base && nohup java -jar ../start.jar &"
  }

```

With the duplicate tasks removed, our Playbook is now much more concise and easy to read.

Re-run the Playbook by running `ansible-playbook ansible/app_servers_automated.yaml -i ansible/inventory.yml` and you should see that the [Tomcat](http://localhost:8080) and [Jetty](http://localhost:9090) servers are setup exactly as before.
```
PLAY [install tomcat] **********************************************************

TASK [Gathering Facts] *********************************************************
ok: [tomcat-server]

TASK [application-server : install java] ***************************************
changed: [tomcat-server]

TASK [application-server : download App Server] ********************************
changed: [tomcat-server]

TASK [application-server : create directory for tomcat installation] ***********
changed: [tomcat-server]

TASK [application-server : unzip app server archive] ***************************
changed: [tomcat-server]

TASK [application-server : move files up one] **********************************
changed: [tomcat-server]

TASK [application-server : start app server] ***********************************
changed: [tomcat-server]

PLAY [install jetty] ***********************************************************

TASK [Gathering Facts] *********************************************************
ok: [jetty-server]

TASK [application-server : install java] ***************************************
changed: [jetty-server]

TASK [application-server : download App Server] ********************************
changed: [jetty-server]

TASK [application-server : create directory for tomcat installation] ***********
changed: [jetty-server]

TASK [application-server : unzip app server archive] ***************************
changed: [jetty-server]

TASK [application-server : move files up one] **********************************
changed: [jetty-server]

TASK [application-server : start app server] ***********************************
changed: [jetty-server]

PLAY RECAP *********************************************************************
jetty-server               : ok=7    changed=6    unreachable=0    failed=0   
tomcat-server              : ok=7    changed=6    unreachable=0    failed=0   

[ OK ] FINISHED - start container with: cic start cic_container-xxxxxxxxxxxxxxxx
```

## Now it's your turn


Write a second Role called `web-frontend` that will install `apache2` and proxy http traffic through to a given port defined by the user of the Role. Apply the `web-frontend` Role to both the `tomcat-server` and `jetty-server` hosts to proxy traffic through to port 8080 on each.

Before starting, visit [http://localhost:8888/](http://localhost:8888/) and [http://localhost:9999](http://localhost:9999/) and you'll notice that neither is accessible. The ports on the end of these URLs are mapped from localhost to port80 on the `jetty-server` and `tomcat-server` hosts, meaning that they should work once you are done.

Write the new Role and implement it correctly within the Playbook to pass the supplied exercise acceptance tests. Run `pytest to execute them. When you have been successful you should see the following:
```
============================= test session starts ==============================
platform linux -- Python 3.7.0, pytest-3.8.2, py-1.6.0, pluggy-0.7.1
rootdir: /vols/pytest_17107, inifile:
plugins: testinfra-1.16.0
collecting 0 items                                                             collecting 2 items                                                             collected 2 items                                                              

tests/webservers_test.py ..                                              [100%]

=========================== 2 passed in 1.88 seconds ===========================
```

#### Helpful Hints
Apache2 can be configured using a [Virtualhost](https://httpd.apache.org/docs/2.4/vhosts/examples.html) definition to proxy traffic to another destination. E.g.

```XML
<VirtualHost *:80>
ProxyPreserveHost On
ProxyPass / http://127.0.0.1:8080/
ProxyPassReverse / http://127.0.0.1:8080/
</VirtualHost>
```
The above virtual host definition proxies all traffic received on port 80 to port 8080 on the loop back address for the current server. Configuration for Apache2 can be found under `/etc/apache2`.

You might find it useful to use the `cic connect` command to connect to one of the servers and experiment.

Remember the changes you make to either of the servers can be undone by shutting the cic test infrastructure down and bringing it back up again using the `cic down` and `cic up commands.

Have fun and good luck! :)

**Note:** once you've finished the exercise, don't forget to run the `cic down` to stop your the environment that you've been using for this tutorial.

## Summary
As Playbooks get larger, Ansible Roles are a good way of encapsulating and sharing common sets of tasks. During this exercise we have looked at how to define Roles, to read more about what can be done with Roles look at the [Ansible Roles documentation](https://docs.ansible.com/ansible/2.5/user_guide/playbooks_reuse_roles.html)



  

Revision: 490d6d8be78192bdf88e87d7de665c88