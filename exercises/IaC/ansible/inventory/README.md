# Inventory

## Introduction
`# Required - Give a written explanation of the purpose of the topic this exercise is based on`

## Exercise Learning Objectives
 - introduce static inventories, hosts and groups
 - outline passing of variables from inventory data

## Useful Terminology
`# Optional - any key terms you intend to use in your exercise, if appropriate, could be listed here`

### Tutorial

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

### Inventory Variables



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
server1 | SUCCESS => {
    "changed": false, 
    "dns_server": "192.168.0.1"
}
server2 | SUCCESS => {
    "changed": false, 
    "dns_server": "192.168.100.1"
}
server3 | SUCCESS => {
    "changed": false, 
    "dns_server": "192.168.100.1"
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
    "changed": false, 
    "dns_server": "192.168.0.1"
}
server2 | SUCCESS => {
    "changed": false, 
    "dns_server": "192.168.100.1"
}
server3 | SUCCESS => {
    "changed": false, 
    "dns_server": "192.168.100.1"
}
```

### Exercise
`# required - Following the tutorial, provide an exercise that requires the participant use the knowledge that they have gained through the intro and tutorial`

### Verification test
`# Ideal but optional - Supply an acceptance test that participants can execute to validate that they have completed the exercise`