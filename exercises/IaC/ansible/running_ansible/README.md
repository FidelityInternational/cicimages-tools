# Run Ansible

## Introduction
> Ansible is an IT automation tool. It can configure systems, deploy software, and orchestrate more advanced IT tasks such as continuous deployments or zero downtime rolling updates.
[Ansible Website](https://docs.ansible.com/ansible/latest/index.html)

Ansible is a powerful tool that removes a number of the complexities of working with remote environments and provides a number of abstractions for expressing tasks that needed be executed and how and when they should occur.

## Exercise Learning Objectives
Ansible has lots of features that you will learn about in future exercises. The aim of this exercise is simply to:
 - give a simple introduction to one of Ansible's primary commands `ansible-playbook`.
 - get you to run some real Ansible on your own environment.
 - provide a gentle lead in to the rest of the exercises in this module.

## Useful terms
- Inventory - these are the hosts that the Ansible will run against. Hosts can be provided in a number of different ways. We'll be going in to this topic in much more detail in other exercises.
- Playbook - The term playbook comes from sports, a playbook contains the named plays or moves that a team might execute in a game.

## Exercise
**Notes**
- Before going any further do the following:
  - `cd YOUR_CLONE_OF_THIS REPO`
  - `source ./bin/env`
  - `cd ./exercises/IaC/ansible/running_ansible`

- So that you don't have to worry about supplying your own infrastructure for ansible to work upon, we have configured the courseware to run ansible against docker containers that we stand up for you. You don't need to know how this works simply that when we mention containers we simply mean where you ansible as run. In the exercise, we'll show you how to connect to these containers to inspect them.

### ansible-playbook
The `ansible-playbook` command is used to execute a group of plays against servers identified in the supplied inventory.

To see what this command can do run: `ansible-playbook --help`. Along with documentation on a large number of options, the following top level documentation should be displayed:
```
Usage: ansible-playbook [options] playbook.yml [playbook2 ...]

Runs Ansible playbooks, executing the defined tasks on the targeted hosts.
```
At the simplest level, all that the `ansible-playbook` command requires is to be pointed at a playbook. One has been supplied for you in `./ansible/apache.yml`:

```YAML
 ---
- name: Setup a webserver.
  hosts: webserver
  become: sudo
  tasks:
    - name: install apache2
      apt:
        name: apache2
        update_cache: yes
        state: latest

    - name: Start service apache2, if not running
      service:
        name: apache2
        enabled: yes
        state: started
```

To use it run:
`ansible-playbook ansible/apache.yml`

You should see the following output which shows ansible running the playbook:
```
PLAY [Setup a webserver.] ******************************************************

TASK [Gathering Facts] *********************************************************
ok: [localhost]

TASK [install apache2] *********************************************************
changed: [localhost]

TASK [Start service apache2, if not running] ***********************************
changed: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=3    changed=2    unreachable=0    failed=0   

[ OK ] FINISHED - start container with: cic start cic_container-xxxxxxxxxxxxxxxx
```

Looking at the output in detail:
 - It has detected a play called 'Setup a webserver'.
 
```
 
```
 - It has collected facts against all hosts in the inventory. We will cover facts later.
 ```
 
```
 - Has installed apache2
```
 
```
 - Has started apache2
```

```
 - Given us a summary of the number of actions that is has taken.
```
 
```

The last line of output looked like this:
```
[ OK ] FINISHED - start container with: cic start cic_container-xxxxxxxxxxxxxxxx
```

This line wasn't outputed by Ansible itself, but actually the courseware supporting this tutorial. This line gives you the command that you can use to start to the temporary container that was created on your behalf for the Ansible to run against.

### Validating that everything has worked
In order to look at what our ansible did, we must first start the container that it ran against.

Start the container that was built for ansible-playbook by running the command that was outputted on your console, e.g: `cic start cic_container-xxxxxxxxxxxxxxxx`






This outputs the following:
```
[OK] Starting container
     Connect with: cic connect cic_container-xxxxxxxxxxxxxxxx
     Stop with   : cic stop cic_container-xxxxxxxxxxxxxxxx
```

The container built out for ansible-playbook is now up and running and ready to be looked at.

**Note:** to stop the container simply run `cic stop cic_container-xxxxxxxxxxxxxxxx`

Using the actual container name given from the `cic start` command run: `cic connect cic_container-xxxxxxxxxxxxxxxx`

You will now be in a bash shell on the container itself. From here run: `curl localhost:80` to see that apache is alive and well.

#### Testing via automation
Automation must be trustworthy if it is to be relied upon. Although we trust that Ansible attempted to do all the things that we asked it to, that doesn't mean that we haven't made a mistake and told it to do the wrong things!

For this reason we always want to be able to run acceptance test(s) to confirm that the delivered system is configured in the way that we were expecting it to be.

Having tests that can be run on demand provides great power. These tests can be used to verify that last minute changes don't break the intended functionality and can even be used post deployment to verify that a system is configured correctly.

This exercise contains a test called ./tests/apache_ansible_test.py written in python using the pytest and testinfra APIs.

To run this script, execute the following command: `pytest --ansible-host=cic_container-xxxxxxxxxxxxxxxx`

This should output the following:
```
============================= test session starts ==============================
platform linux -- Python 3.7.0, pytest-3.8.2, py-1.7.0, pluggy-0.7.1 -- /root/.pyenv/versions/3.7.0/bin/python3.7
cachedir: .pytest_cache
rootdir: /vols/pytest_27848, inifile: pytest.ini
plugins: testinfra-1.16.0
collecting 0 items                                                             collecting 3 items                                                             collected 3 items                                                              

tests/apache_ansible_test.py::test_apache_installed PASSED               [ 33%]
tests/apache_ansible_test.py::test_apache_is_enabled_as_service PASSED   [ 66%]
tests/apache_ansible_test.py::test_apache_installed_is_running PASSED    [100%]

=========================== 3 passed in 0.81 seconds ===========================
```

In just a second or so the test has validated that:
- the correct package was installed.
- apache2 daemon had been started
- the apache2 process is running

Now that the acceptance tests are passing we can be very confident that the system has been configured as required.

## Summary
Ansible is a great tool for configuring infrastructure. Baked in to its philosophy is that all configuration is code and so can and should be version controlled. In the other exercises in this module you will learn how to write and test your own playbooks as well as learn about Ansible's other powerful features.

  

Revision: 1d412bf7bf93ef8178835a22e745638e