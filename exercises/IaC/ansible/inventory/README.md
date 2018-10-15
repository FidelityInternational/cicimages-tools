# Inventory

## Introduction
Ansible requires a list of hosts to execute playbooks and ad-hoc commands against.  Ansible refers
to this target host list as an inventory.  This exercise will outline some basic inventory concepts -
inventory formats, grouping, setting and using variables.

## Exercise Learning Objectives

  - Provide an overview of static inventories
  - Introduce hostgroups and variables
  - Create a static inventory with hostgroups and variables

## Introduction to Static Inventories

### Formats

Ansible supports a number of inventory file formats:

  - INI style static files
  - JSON/YAML static files
  - Any executable that outputs valid JSON/YAML
  - Directories; Ansible will read all inventory files in the specified directory
  - Python plugins

You can find mode information on supported inventory formats in the official
[Ansible documentation](https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html).

### Basic Inventory

Ansible commands will look for the default inventory file in `/etc/ansible/hosts`.  The inventory can be overridden
on the command line using the `-i INVENTORY` option or via the `ansible.cfg` config file.

The default inventory file can be a simple list of hostnames:

```
server1
server2
server3
```

### Inventory Groups

As well as a simple list of hosts, inventories allow hosts to be grouped:

```
[webservers]
server1

[dbservers]
server2
server3

[dc1hosts]
server2

[dc2hosts]
server1
server3
```

Host can be defined in more than one group.

Groups can be used to limit the scope of playbooks and ad-hoc commands, we can target groups using the
`hosts:` parameter in our playbooks.  For example, take the following playbook as an example:

```YAML
---
- hosts: dc1hosts
  tasks:
    - name: Run command (only on hosts in DC1)
      command: /bin/somecommand
```

Tasks in the play will only run on hosts in the `dc1hosts` group.

Restrictions can also be placed via the `-l LIMIT` option on the command line:

```
ansible -m ping all -l dc2hosts
```

In this case, the `all` built-in group is initially specified but is subsequently limited to hosts only in the
`dc2hosts` group.

### Inventory Variables

Variables can be defined in the inventory file and made available to the Ansible run, variables can be set,
per host, within the inventory file:

```
[webservers]
server1   dns_server=1.1.1.1

[dbservers]
server2   dns_server=2.2.2.2   ntp_server=4.4.4.4
server3   dns_server=3.3.3.3   ntp_server=4.4.4.4
```

They can also be defined by group with a special section in the inventory file:

```
[webservers]
server1

[dbservers]
server2
server3

[webservers:vars]
dns_server=1.1.1.1

[dbservers:vars]
dns_server=2.2.2.2
```

This allows hosts to be added to the `webservers` or `dbservers` groups without having to specify the
`dns_server` variable directly.

## Exercise

**Note:** Before starting the exercises, please do the following:

- `cd YOUR_CLONE_OF_THIS REPO`
- `. ./bin/.env`
- `cd ./exercises/IaC/ansible/inventory`
- `cic up`


These commands will configure an environment and will bring up three docker containers for use in the exercises
that follow.

### Creating A Basic Inventory

[webservers]
server1

[dbservers]
server2
server3 dns_server=3.3.3.3

[webservers:vars]
dns_server=1.1.1.1

[dbservers:vars]
dns_server=2.2.2.2


Create an inventory file `ansible/inventory` within the exercise directory, it define a static inventory
as follows:

```
[webservers]
server1

[dbservers]
server2
server3 dns_server=3.3.3.3

[webservers:vars]
dns_server=1.1.1.1

[dbservers:vars]
dns_server=2.2.2.2

```

The `dns_server` variable will be available during an Ansible run, you can check that the variable is being
set by using the `ansible` command and the debug module:

```
ansible -i ansible/inventory -m debug -a var=dns_server all -o
```

Which should show output as follows:

```
server2 | SUCCESS => {    "changed": false,    "dns_server": "2.2.2.2"}
server3 | SUCCESS => {    "changed": false,    "dns_server": "3.3.3.3"}
server1 | SUCCESS => {    "changed": false,    "dns_server": "1.1.1.1"}
```

The output shows the result of running the `debug` module on each of the three hosts in the inventory file.
In each case, the `dns_server` variable was set to the value defined in the static inventory.

### Scenario

A colleague has handed over a playbook for you to run on some newly commissioned servers.  Two of the
servers are physically located in the UK and one in Asia.  It has been decided that the /etc/issue file
should be configured to show the server's region and some other details when a user logs in.

Create a new static inventory that:

  - Defines the three servers (`server1`, `server2`, `server3`)
  - Groups the servers into two groups `ukservers` and `asiaservers` (server1 is in the UK, server2 and
    server3 are in Asia)
  - Ensures that a `region` variable is set for every `ansible-playbook` run
  - Should allow other servers to be easily added to each group without having to set the region variable

As part of this work, your colleague has also supplied you with a small acceptance test for you to
ensure that all servers are correctly configured after the playbook run.



You can execute the playbook by running `ansible-playbook -i ansible/inventory ansible/configure-issue.yml`

Execute the tests by running `pytest`, you should get the following output once you have created a valid
inventory file and run the playbook successfully:


```
============================= test session starts ==============================
platform linux -- Python 3.7.0, pytest-3.8.2, py-1.7.0, pluggy-0.7.1 -- /root/.pyenv/versions/3.7.0/bin/python3.7
cachedir: .pytest_cache
rootdir: /vols/pytest_28930, inifile: pytest.ini
plugins: testinfra-1.16.0
collecting 0 items                                                             collecting 2 items                                                             collecting 3 items                                                             collected 3 items                                                              

tests/asiaservers_test.py::test_motd[paramiko://server2] PASSED          [ 33%]
tests/asiaservers_test.py::test_motd[paramiko://server3] PASSED          [ 66%]
tests/ukservers_test.py::test_motd[paramiko://server1] PASSED            [100%]

=============================== warnings summary ===============================
<unknown>:7: DeprecationWarning: invalid escape sequence \s
<unknown>:7: DeprecationWarning: invalid escape sequence \s

-- Docs: https://docs.pytest.org/en/latest/warnings.html
===================== 3 passed, 2 warnings in 1.24 seconds =====================
```

## Summary
In this tutorial and exercises, you should have seen that:

  - Ansible supports multiple inventory formats
  - Inventories can contain groups and variables (as well as lists of hosts)
  - Hosts can be part of multiple groups
  - Variables can be assigned to hosts or to groups
  - You can use limit strings (or the hosts: parameter) to restrict which groups Ansible targets

  

Revision: 053ef1c15d9418de72c8e10efdca9bf4