# Variables


## Introduction
Variables are crucial to allowing the Ansible we write to be reusable. The cost of maintaining code that is effectively duplicated barring values that make it specific to a given environment is a risky business. Snow blindness can easily set in and seemingly weird errors can occur if you you forget to rollout a change across all of the duplicate code. If only it was possible to inject the values that need to vary from one execution to the next... That's where variables come in.

In this exercise we'll introduce the different ways that Ansible provides of supplying variables and the reasons for using them.

## Exercise Learning Objectives
In this exercise you'll learn how to use variables to:
  - manage differences across systems
  - keep code and configuration separate.
  - organise your configuration.

## Useful Terminology
- DRY (Don't Repeat Yourself) - keeping code DRY is a very simple but important idea, that being that the duplication is best avoided so keep your code DRY and don't repeat yourself.

**Note:** Before starting the exercises, please do the following:
  - `cd YOUR_CLONE_OF_THIS REPO`
  - `source ./bin/env`
  - `cd ./exercises/IaC/ansible/variables`
  - `cic up`


Having run this command, test infrastructure consisting of all the environments you will need has been stood up for you.

Runing cic down will stop these environments and drop any changes that you have made to them.

## Referencing variables
Consider the following playbook:



```YAML
- name: Variables example
  hosts: localhost
  tasks:
    - name: Display a variable
      debug: msg="Hello {{name_variable}}, how are you?"


```

Against the 'Display a variable' task you'll notice a string containing `{{name_variable}}` is being passed to the `debug` module. This notation denotes a variable called: `name_variable` is expected to be supplied at runtime.

**Note:** Playbooks are processed using the [Jinja2 templating engine](http://jinja.pocoo.org/docs/2.10/). With the exception of the `when:` attribute, variables are always referenced via `{{ VARIABLE }}` notation.

There are number of different ways of supply the value for a variable

### Supplying from variables through the commandline
Write the above ansible to a file ansible/hello_world.yml and run: ansible-playbook ansible/hello_world.yml -c local --extra-vars="name_variable=Micky"

This should produce the following output:
```
PLAY [Variables example] *******************************************************

TASK [Gathering Facts] *********************************************************
ok: [127.0.0.1]

TASK [Display a variable] ******************************************************
ok: [127.0.0.1] => {
    "msg": "Hello Micky, how are you?"
}

PLAY RECAP *********************************************************************
127.0.0.1                  : ok=2    changed=0    unreachable=0    failed=0   

[ OK ] FINISHED - start container with: cic start cic_container-xxxxxxxxxxxxxxxx
```

## Inline variable declarations
Duplication is a code smell. Assigning repeated values to variables is a good way of removing this duplication and making code easier to maintain.

Variables can be declared directly within a Playbook, Inventory, Tasks and Roles.

Consider the following Playbook:

```YAML
- name: Variables example
  hosts: localhost
  tasks:
    - name: Say hello
      debug: msg="Hello Micky, how are you?"
    - name: Say goodbye
      debug: msg="Hello Micky, goodbye and have a nice day"

```



Whilst it's trivial, it demonstrates some duplication. In this case the name 'Micky'' is repeated and so is the greeting 'Hello'. We can define variables within the playbook and the tasks themselves to DRY things up.


```YAML
- name: Variables example
  vars:
    name_variable: "Micky"
    greeting: "Hello"
  hosts: localhost
  tasks:
  - name: Say hello
    debug: msg="{{greeting}} {{name_variable}}, how are you?"
  - name: Say goodbye
    vars:
      greeting: 'Yo!'
    debug: msg="{{greeting}} {{name_variable}}, goodbye and have a nice day"

```

In the above, both `name_variable` and `greeting` have been pulled out to variable. In the second task the `greeting` variable has been overridden by declaring it again within the task itself.

```
PLAY [Variables example] *******************************************************

TASK [Gathering Facts] *********************************************************
ok: [127.0.0.1]

TASK [Say hello] ***************************************************************
ok: [127.0.0.1] => {
    "msg": "Hello Micky, how are you?"
}

TASK [Say goodbye] *************************************************************
ok: [127.0.0.1] => {
    "msg": "Yo! Micky, goodbye and have a nice day"
}

PLAY RECAP *********************************************************************
127.0.0.1                  : ok=3    changed=0    unreachable=0    failed=0   

[ OK ] FINISHED - start container with: cic start cic_container-xxxxxxxxxxxxxxxx
```

## Scope/Precidence
Ansible has 3 mains scopes:
- Global - These are values set in config, environment variables or on the commandline
- Per play
- Per host

More details on how Ansible handles variable scope can be found in the [Ansible Documentation](https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html#variable-scopes).

In Ansible, variables can be declared in a number of different places and have a different precedence depending on where they are defined. For example, variables set via the commandline have the highest precedence. In the given the example above, values for the `name` and `greeting` were defined at the playbook level. These can be overidden using the variables defined at the commandline level which running `ansible-playbook -c local ansible/hello_world.yml --extra-vars='name_variable=Daffy'` shows.
```
PLAY [Variables example] *******************************************************

TASK [Gathering Facts] *********************************************************
ok: [127.0.0.1]

TASK [Say hello] ***************************************************************
ok: [127.0.0.1] => {
    "msg": "Hello Daffy, how are you?"
}

TASK [Say goodbye] *************************************************************
ok: [127.0.0.1] => {
    "msg": "Yo! Daffy, goodbye and have a nice day"
}

PLAY RECAP *********************************************************************
127.0.0.1                  : ok=3    changed=0    unreachable=0    failed=0   

[ OK ] FINISHED - start container with: cic start cic_container-xxxxxxxxxxxxxxxx
```

Take a look at the [Ansible docs on precedence](https://docs.ansible.com/ansible/2.5/user_guide/playbooks_variables.html#variable-precedence-where-should-i-put-a-variable) for more information.

## Keeping config seperate

### Variables files


Not every system that you are installing will be identical. Take for example the scenario where you are setting up the development and production environments for a continuous deployment pipeline. It can be useful for these environments to be subtly different. For example maybe having the commandline prompt differentiate an environment as either belonging to development or production.

Variables are a good way of managing the differences between target systems without the need to introduce logic, as we will now see.



When `cic up` was run, the following environments with given hostnames were  stood up:

- dev1
- prod1
- prod2

To connect to any of these environment simply use the `cic connect` connect command, e.g.  `cic connect dev1`


Write the following development specific config to `ansible/vars/dev.yml`
```YAML
---
prompt: DEV

```


Write the following production specific config to `ansible/vars/prod.yml`
```YAML
---
prompt: DEV

```

Each of the files defines a variable `prompt` that will be displayed on the console.

**Note** There is nothing special about the folder name `vars`, its purely arbitrary.





These variable files can be loaded via the [include_vars](https://docs.ansible.com/ansible/latest/modules/include_vars_module.html) module. Write the following playbook too ansible/prompt.yml
```YAML
---
- hosts: all
  tasks:
    - name: Include per-environment variables
      include_vars: "vars/{{ app_env }}.yml"

    - name: Set root prompt
      lineinfile:
        dest: /root/.bashrc
        line: 'PS1="[{{prompt}}]$ "'
        insertbefore: EOF

```

Here we can see that the `include_vars` module is being used to load the variables. The file that the variables should be loaded from are determined by inspecting the value of the `app_env` variable at run time. The `app_env` variable could be set against each server definition in the inventory for example. Write the following to ansible/inventory, which does just that.

```YAML
[dev-servers]
dev1 app_env=dev

[prod-servers]
prod1 app_env=dev
prod2 app_env=dev

```

Before running the playbook, run `cic connect dev1` and note that the prompt does contain the text `dev`. After executing the playbook by running `ansible-playbook ansible/prompt.yml -i ansible/inventory`, connect back to dev1 and you will see that the prompt now reads as required.

### Organising your config with `group_vars` and `host_vars`
Separating config from code is a principle of good software development, and Ansible provides strong conventions which make providing configuration for hosts and groups of hosts easy.

 The host specific variables are prioritised over variables defined for a group, meaning that group wide variables can easily be overridden.

 host and group based variables files should be put in to the `host_vars` and `group_vars` directories respectively. Each of these directories should be local to the playbook.

Host variable files should be named after the hosts for which they contain variables. For example if inventory contains a host named `server1` then the corresponding host_vars file would be `host_vars/server1.yml`. The same is true for group variables files. I.e. they should be located within the `group_vars` folder and be named after the group as it is identified within inventory. E.g. if a group was defined in the inventory as `dev-servers` then the corresponding group variables file would be at `group_vars/dev-servers.yml`

The playbook in the previous example, whilst flexible, contained a code smell in that the Inventory file duplicates the `app_env` variable for each host.


Both the Inventory and Playbook can be dried up by making use of Ansible's `group_vars` feature. Update `ansible/inventory` to remove the declaration of `app_env` for each host. This should mean that the inventory now looks like the following:
```YAML
[dev-servers]
dev1

[prod-servers]
prod1
prod2

```

The following group variables files can be used instead.



ansible/group_vars/prod-servers.yml
```YAML
prompt: PROD

```
ansible/group_vars/dev-servers.yml
```YAML
prompt: DEV

```



Now that `app_env` is no longer required we can also remove the `include_vars` statement from the playbook. Update ansible/prompt.yml to read as follows:

```YAML
---
- hosts: all
  tasks:
    - name: Set root prompt
      lineinfile:
        dest: /root/.bashrc
        line: 'PS1="[{{prompt}}]$ "'
        insertbefore: EOF


```

Run `cic down` and then `cic up` to reset the test infrastructure and rerun ansible-playbook ansible/prompt.yml -i ansible/inventory
```
PLAY [all] *********************************************************************

TASK [Gathering Facts] *********************************************************
ok: [prod2]
ok: [dev1]
ok: [prod1]

TASK [Set root prompt] *********************************************************
changed: [prod2]
changed: [prod1]
changed: [dev1]

PLAY RECAP *********************************************************************
dev1                       : ok=2    changed=1    unreachable=0    failed=0   
prod1                      : ok=2    changed=1    unreachable=0    failed=0   
prod2                      : ok=2    changed=1    unreachable=0    failed=0   

[ OK ] FINISHED - start container with: cic start cic_container-xxxxxxxxxxxxxxxx
```

Use the `cic connect` command to connect to any of the servers and you will see that their prompts continue to be set correctly.

## Now it's your turn!
The operations team are looking after the development and production environments for an application. The two environments are made up 2 development server and 2 production servers.

Their hostnames are:

- dev-app1
- dev-app2
- prod-app1
- prod-app2

The application deployed to these environments requires a file to be located at `/etc/app.id`. This file should containing a single line in the format:

```APPSTRING:ENVIRONMENT:HOSTNAME```

- `APPSTRING` is a static string - almost always `ABCAPP`, but sometimes the team need to change this for ad-hoc testing, so they would like this to default to ```CIC_WEBAPP``` but be overridable from the command line.

- `ENVIRONMENT` is the environment that the server is a member of. This should be DEV for development machines and PROD for production machines.

- `HOSTNAME` is the hostname of the system.  Ansible makes this information available to you, you just need to find out how :)

Your mission, should you choose to accept it, is to create a Playbook to meet this requirement.


You'll know when you got the job done when you are able to run the command `pytest` and see the following output:
```
============================= test session starts ==============================
platform linux -- Python 3.7.0, pytest-3.8.2, py-1.7.0, pluggy-0.7.1 -- /root/.pyenv/versions/3.7.0/bin/python3.7
cachedir: .pytest_cache
rootdir: /vols/pytest_7982, inifile: pytest.ini
plugins: testinfra-1.16.0
collecting 0 items                                                             collecting 4 items                                                             collected 4 items                                                              

tests/devservers_test.py::test_dev_app1_server PASSED                    [ 25%]
tests/devservers_test.py::test_dev_app2_server PASSED                    [ 50%]
tests/devservers_test.py::test_prod_app1_server PASSED                   [ 75%]
tests/devservers_test.py::test_prod_app2_server PASSED                   [100%]

=========================== 4 passed in 1.68 seconds ===========================
```

## Summary
Variables are very useful for removing a range of code smells that make our code less easy to read or maintain. They also are invaluable improving the re-usability of our code.
Ansible provides a rich feature set that makes it easy to:

  - Supply variables that apply global but can still be overridden
  - Separate and organise config independent of the code itself.
  - [Jinja2](http://jinja.pocoo.org/docs/2.10/) provides some powerful options when it comes to computing variable values at runtime.

**Note:** Now that you've finished the exercise, remember to run `cic down` to shutdown your test infrastructure.

  

Revision: fd46e6391c75b5f2cdee1374b01c8d99