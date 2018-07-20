# Inventory

## Introduction
`# Required - Give a written explanation of the purpose of the topic this exercise is based on`

## Exercise Learning Objectives
 - introduce static inventories, hosts and groups
 - outline passing of variables from inventory data

## Useful Terminology
`# Optional - any key terms you intend to use in your exercise, if appropriate, could be listed here`

## Tutorial

Ansible requires a list of hosts to execute playbooks and commands against, this is reffered to as
the inventory.

In it's most basic form an inventory file can be a simple list of hosts:

```
host1.example.org
host2.example.org
host3.example.org
```

Hosts can also be grouped using INI style headers:

```
[webservers]
host1.example.org
[dbservers]
host2.example.org
host3.example.org
[dc1hosts]
host2.example.org
[dc2hosts]
host1.example.org
host3.example.org
```

Host can be defined in more than one group.

Ansible supports INI style static inventories as well as YAML and JSON (see
[Ansible documentation](https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html#hosts-and-groups)).

By default Ansible commands will look for the default inventory file in `/etc/ansible/hosts`.  The inventory
can be overridden on the command line using the `-i INVENTORY` option.

### Using Groups

Groups can be used to limit the scope of ansible playbooks and ad-hoc commands, we can target groups using the
`hosts:` parameter in our playbooks, for example:

```
---
- hosts: dc1hosts
  tasks:
    - name: Run command (only on hosts in DC1)
      command: /bin/somecommand
```

The scope of the entire play is limited to only hosts in the `dc1hosts` group.

### Using Variables



Variables can be defined in the inventory file and made available to the Ansible run.  Create a basic inventory
file, `ansible/myinventory`, with the contents:

```
[webservers]
server1   dns_server=192.168.0.1
[dbservers]
server2   dns_server=192.168.100.1
server3   dns_server=192.168.100.1

```

The `dns_server` variable would be available to the Ansible run, you can check that the variable is being
set by using the `ansible` command and the debug module:

```
`ansible -i ansible/myinventory -m debug -a var=dns_server all`
```

Which should show output as follows:

```
server2 | SUCCESS => {
    "dns_server": "192.168.100.1"
}
server3 | SUCCESS => {
    "dns_server": "192.168.100.1"
}
server1 | SUCCESS => {
    "dns_server": "192.168.0.1"
}
```



The output shows the result of running the `debug` module on each of the three hosts in the inventory file.
In each case, the `dns_server` variable was set to the value defined in the static inventory.

Variables can also be set for all hosts in a group, edit the `ansible/myinventory`
file again and add the `[dbservers:vars]` section and add the `dns_server` variable for the group rather than
for `server2` and `server3` directly:

```
[webservers]
server1   dns_server=192.168.0.1
[dbservers]
server2
server3
[dbservers:vars]
dns_server=192.168.100.1

```

When the command is run again:

```
`ansible -i ansible/myinventory -m debug -a var=dns_server all`
```

We should get the same output.

```
server1 | SUCCESS => {
    "dns_server": "192.168.0.1"
}
server2 | SUCCESS => {
    "dns_server": "192.168.100.1"
}
server3 | SUCCESS => {
    "dns_server": "192.168.100.1"
}
```

## Exercise

**Note:** Before going any further do the following:
- `cd YOUR_CLONE_OF_THIS REPO`
- `source ./bin/.env`
- `./exercises/IaC/ansible/inventory`

### Scenario

A colleague has handed over a playbook for you to run on some newly commissioned servers.  Two of the
servers are physically located in the UK and one in Asia. To minimise NTP time synchronisation issues
the servers should be configured using the regional ntp.org pool servers.

The production ntp.conf template file has been provided, but it requires a `region` parameter to be
set during the `ansible-playbook` execution so that the correct configuration is applied.

Create a new static inventory that:

  - Defines the three servers (`server1`, `server2`, `server3`)
  - Groups the servers into two groups `ukservers` and `asiaservers`
  - Ensures that a `region` variable is set for every `ansible-playbook` run

As part of this work, your colleague has also supplied you with a small acceptance test for you to
ensure that all servers are correctly configured after the playbook run.

Execute the tests by running `pytest`
```
============================= test session starts ==============================
platform linux2 -- Python 2.7.12, pytest-3.6.3, py-1.5.4, pluggy-0.6.0 -- /usr/bin/python
cachedir: .pytest_cache
rootdir: /vols/pytest_25951, inifile: pytest.ini
plugins: testinfra-1.14.0
collecting ... collected 3 items

tests/ntp_config_test.py::test_inventory_server1_config[local] FAILED    [ 33%]
tests/ntp_config_test.py::test_inventory_server2_config[local] FAILED    [ 66%]
tests/ntp_config_test.py::test_inventory_server3_config[local] FAILED    [100%]
```

### Verification test
`# Ideal but optional - Supply an acceptance test that participants can execute to validate that they have completed the exercise`