### Introduction
There comes a time where logic and looping become useful. Ansible provides conditional constructs to cater for this.

Conditionals allow the result of a play to vary based on the value of variables, or the results of previous tasks.

### Learning Objectives

How to use Conditionals to add logic to Playbooks.

## Prerequisite knowledge

It is assumed that you are familiar with the basics of Ansible, such that you can define a simple Playbook.

**Note:** Before going any further do the following:

- `cd YOUR_CLONE_OF_THIS REPO`
- `source ./bin/env`
- `cd /exercises/IaC/ansible/conditionals`

Run `cic up` to bring up all the test infrastructure and support files required to complete this exercise. To stop and reset this infrastructure run `cic down`.

## The When Statement
The When Statement defines the condition for **when** a task should be executed




The condition is declared within the task itself using the `when` clause. The following example declares 2 tasks:
- `Runtime requirements check` - This will fail if the `installation_dir` variable is not supplied
- `Setup runtime` - which outputs a message if the `log_level` variable is supplied.

```YAML

---
- name: setup environment
  hosts: all
  tasks:
  - name: Runtime requirements check
    fail: msg="Required variable 'installation_dir' not set"
    when: installation_dir is undefined

  - name: Setup runtime
    debug: 
      msg: Logging at '{{ log_level }}'
    when: log_level is defined


```

In this example the when clause is defined using a 'test'. There are many ways you can utilise tests to define your conditionals, more information can be found [here.](https://docs.ansible.com/ansible/2.5/user_guide/playbooks_tests.html)

Write the above yaml to `ansible/when.yml` so that you can try running it.

Running `ansible-playbook ansible/when.yml -c local`, i.e. not supplying the required `installation_dir` causes the first of our tasks to fail:

```

PLAY [setup environment] *******************************************************

TASK [Gathering Facts] *********************************************************
ok: [127.0.0.1]

TASK [Runtime requirements check] **********************************************
fatal: [127.0.0.1]: FAILED! => {"changed": false, "msg": "Required variable 'installation_dir' not set"}
	to retry, use: --limit @/vols/ansible_5628/ansible/when.retry

PLAY RECAP *********************************************************************
127.0.0.1                  : ok=1    changed=0    unreachable=0    failed=1   
```

We can fix this by supplying the `installation_dir` variable using the the `--extra-vars` option. Run `ansible-playbook ansible/when.yml -c local --extra-vars='installation_dir=/var'`

```
PLAY [setup environment] *******************************************************

TASK [Gathering Facts] *********************************************************
ok: [127.0.0.1]

TASK [Runtime requirements check] **********************************************
skipping: [127.0.0.1]

TASK [Setup runtime] ***********************************************************
skipping: [127.0.0.1]

PLAY RECAP *********************************************************************
127.0.0.1                  : ok=1    changed=0    unreachable=0    failed=0   

[ OK ] FINISHED - start container with: cic start cic_container-xxxxxxxxxxxxxxxx
```

You'll notice that this time the playbook executed successfully but that the `Setup runtime` task did not execute. This is because we did not supply the optional `log_level` variable that our when condition was looking for.

Run: `ansible-playbook ansible/when.yml -c local --extra-vars='installation_dir=/var log_level=debug'` to see the `Setup runtime`
task execute.


```

PLAY [setup environment] *******************************************************

TASK [Gathering Facts] *********************************************************
ok: [127.0.0.1]

TASK [Runtime requirements check] **********************************************
skipping: [127.0.0.1]

TASK [Setup runtime] ***********************************************************
skipping: [127.0.0.1]

PLAY RECAP *********************************************************************
127.0.0.1                  : ok=1    changed=0    unreachable=0    failed=0   

[ OK ] FINISHED - start container with: cic start cic_container-xxxxxxxxxxxxxxxx
```



### And/Or

To combine multiple conditions you can make use of 'or' and 'and', where the play will execute if one of the conditions is met, or if both of the conditions are met, respectively.

Write to `ansible/or_condition.yml` with the following yaml:

```YAML

---
- name: Global working hours
  hosts: all
  vars:
    day: Saturday

  tasks:
  - debug:
      msg: "There is currently no one in the office, please try again later"
    when: day=="Saturday" or day=="Sunday"

```

Running `ansible-playbook ansible/or_condition.yml -c local`, will print the out of office statement, because the `day` variable has been set to Saturday.

```

PLAY [Global working hours] ****************************************************

TASK [Gathering Facts] *********************************************************
ok: [127.0.0.1]

TASK [debug] *******************************************************************
ok: [127.0.0.1] => {
    "msg": "There is currently no one in the office, please try again later"
}

PLAY RECAP *********************************************************************
127.0.0.1                  : ok=2    changed=0    unreachable=0    failed=0   

[ OK ] FINISHED - start container with: cic start cic_container-xxxxxxxxxxxxxxxx
```

Alternatively, we can require both conditions to be met by using the `and` operator. Write the following YAML to `ansible/and_condition`:

```YAML

---
- name: Global working hours
  hosts: all
  vars:
    day: Monday
    time: 5

  tasks:
  - debug:
      msg: "There is currently no one in the office, please try again later"
    when: day=="Monday" and time>=5

```

In this example we have met both conditions with values set against `day` and `time` so can expect the message to be printed.

Run `ansible-playbook ansible/and_condition -c local` to see that this happens.

```

PLAY [Global working hours] ****************************************************

TASK [Gathering Facts] *********************************************************
ok: [127.0.0.1]

TASK [debug] *******************************************************************
ok: [127.0.0.1] => {
    "msg": "There is currently no one in the office, please try again later"
}

PLAY RECAP *********************************************************************
127.0.0.1                  : ok=2    changed=0    unreachable=0    failed=0   

[ OK ] FINISHED - start container with: cic start cic_container-xxxxxxxxxxxxxxxx
```
## Loops
Often it will be necessary to perform the same action a multiple number of times. For example creating new users in a database. This is where loops come into play.

### Simple loops

Ansible provides the `loop` directive. It expects to be given a list of values. This list can be defined inline or can be the output of a [Jinja2 Expression](http://jinja.pocoo.org/docs/2.10/templates/#expressions).

The following playbook defines a simple task that prints out a message for each item in the loop. The `loop` directive has been given the list of users identified in the `users` variable. By default Ansible will assign the current value which is the subject of a given iteration to a variable called `item`.

```YAML

---
- name: create users
  hosts: all
  vars:
    users: [user1, user2, user3]
  tasks:
    - name: create users
      debug:
        msg: "creating user: {{item}}"
      loop: "{{users}}"

```

Write this example playbook to `ansible/simple_loop.yml` and run it with `ansible-playbook ansible/simple_loop.yml`.

```

PLAY [create users] ************************************************************

TASK [Gathering Facts] *********************************************************
ok: [127.0.0.1]

TASK [create users] ************************************************************
ok: [127.0.0.1] => (item=user1) => {
    "msg": "creating user: user1"
}
ok: [127.0.0.1] => (item=user2) => {
    "msg": "creating user: user2"
}
ok: [127.0.0.1] => (item=user3) => {
    "msg": "creating user: user3"
}

PLAY RECAP *********************************************************************
127.0.0.1                  : ok=2    changed=0    unreachable=0    failed=0   

[ OK ] FINISHED - start container with: cic start cic_container-xxxxxxxxxxxxxxxx
```

As you can see the message has been printinted for each of the values in the `users` list.

### Looping through hashes: `dict2items`

Often data will be stored in a map structure, I.e. key, value pairs. Maps are also known as Dictionaries, Hashes or Associative Arrays. The following playbook shows a variable `user_group_mappings` which maps users to the groups they belong to. In order to convert this map in to a compatible list structure that can be passed to `loop` this is where the [Jinja Filter](https://docs.ansible.com/ansible/2.7/user_guide/playbooks_filters.html) [`dict2items`](https://docs.ansible.com/ansible/2.7/user_guide/playbooks_filters.html#dict-filter) comes in to play. The `dict2items` filter flattens a hash structure in to a list. The filter can be used as part of an expression like the following: `{{user_group_mappings | dict2items}}`

```YAML
- name: Map to list example
  hosts: all
  vars:
    user_group_mappings:
      admin:
        - user1
        - user2
      team:
        - user3
        - user4
        - user5

  tasks:
  - name: 'create user'
    debug:
      msg: "Creating user: {{item['value']}} in group: {{item['key']}}"
    loop: "{{ user_group_mappings| dict2items  }}"

```

In the case of the above playbook `dict2items` takes the `user_group_mappings` variable and returns the following:

```YAML
- key: admin
  value: [ user1, user2 ]
- key: team
  value: [ user3, user4, user5]

Which can be iterated over using the standard `loop` construct.

```
write the playbook to `ansible/hash_to_list.yml` and Run it with: `ansible-playbook ansible/hash_to_list.yml`. This will output the following:
```

PLAY [Map to list example] *****************************************************

TASK [Gathering Facts] *********************************************************
ok: [127.0.0.1]

TASK [create user] *************************************************************
ok: [127.0.0.1] => (item={'key': 'admin', 'value': ['user1', 'user2']}) => {
    "msg": "Creating user: ['user1', 'user2'] in group: admin"
}
ok: [127.0.0.1] => (item={'key': 'team', 'value': ['user3', 'user4', 'user5']}) => {
    "msg": "Creating user: ['user3', 'user4', 'user5'] in group: team"
}

PLAY RECAP *********************************************************************
127.0.0.1                  : ok=2    changed=0    unreachable=0    failed=0   

[ OK ] FINISHED - start container with: cic start cic_container-xxxxxxxxxxxxxxxx
```

As you can see, the `user_group_mappings` variable has been successfully used within the loop.

### Nested loops
Putting one loop within another is also possible. In order to surround a group of tasks with a loop they must be imported using the `include_tasks` plugin. The tasks below doing the following:

- print a message to say that the group defined in the `group_name` variable is being created
- `loop` through the list defined in the `users` variable and print a message for item in it.

```YAML

- name: "create group"
  debug:
    msg: "crearting group: {{group_name}}"

- name: "create users"
  debug:
    msg: "creating user: {{item}}"
  loop: "{{users}}"

```

The following playbook then includes the tasks above and puts a `loop` condition against them.

```YAML

---
- name: super loop
  hosts: all
  vars:
    user_group_mappings:
      Admin:
      - user1
      - user2
      Team:
      - user3
      - user4
      - user5

  tasks:
  - include: create_users_and_groups.yml group_name="{{item['key']}}" users="{{item['value']}}"
    loop: "{{ user_group_mappings| dict2items }}"

```

The playbook starts with the same `user_group_mappings` hash as the previous example so uses the `dict2items` filter to convert it. Each time around the loop the group name (`item['key']`) and and list of users (`item['value']`) are assigned to the variable names that are defined in the included tasks.

Write the tasks to `ansible/create_users_and_groups.yml` and the playbook to `ansible/nested_loops.yml`. Now run the playbook with: `ansible-playbook ansible/nested_loops.yml`. This will show the following:

```

PLAY [super loop] **************************************************************

TASK [Gathering Facts] *********************************************************
ok: [127.0.0.1]

TASK [include] *****************************************************************
included: /vols/ansible_23846/ansible/create_users_and_groups.yml for 127.0.0.1 => (item={'key': 'Admin', 'value': ['user1', 'user2']})
included: /vols/ansible_23846/ansible/create_users_and_groups.yml for 127.0.0.1 => (item={'key': 'Team', 'value': ['user3', 'user4', 'user5']})

TASK [create group] ************************************************************
ok: [127.0.0.1] => {
    "msg": "crearting group: Admin"
}

TASK [create users] ************************************************************
 [WARNING]: The loop variable 'item' is already in use. You should set the
`loop_var` value in the `loop_control` option for the task to something else to
avoid variable collisions and unexpected behavior.

ok: [127.0.0.1] => (item=user1) => {
    "msg": "creating user: user1"
}
ok: [127.0.0.1] => (item=user2) => {
    "msg": "creating user: user2"
}

TASK [create group] ************************************************************
ok: [127.0.0.1] => {
    "msg": "crearting group: Team"
}

TASK [create users] ************************************************************
 [WARNING]: The loop variable 'item' is already in use. You should set the
`loop_var` value in the `loop_control` option for the task to something else to
avoid variable collisions and unexpected behavior.

ok: [127.0.0.1] => (item=user3) => {
    "msg": "creating user: user3"
}
ok: [127.0.0.1] => (item=user4) => {
    "msg": "creating user: user4"
}
ok: [127.0.0.1] => (item=user5) => {
    "msg": "creating user: user5"
}

PLAY RECAP *********************************************************************
127.0.0.1                  : ok=7    changed=0    unreachable=0    failed=0   

[ OK ] FINISHED - start container with: cic start cic_container-xxxxxxxxxxxxxxxx
```

Here we can see that the included tasks have been run twice, once for each of the user groups, and that the nested loop as also executed correctly.

**Note:** The `item` variable assigned by `loop` is reassigned by the nested `loop` statement. If this becomes a problem, the variable name used can be set using the `loop_control` option. See the [loop_control documentation](https://docs.ansible.com/ansible/2.7/user_guide/playbooks_loops.html#loop-control) for more details.

### Other features
There are a number of other features that ansible provides regarding loops. For example the `until` clause that can be used to short circuit the execution of a loop when a particular condition is met. For details on the other things that can be done within loops see the [Ansible loops documentation](https://docs.ansible.com/ansible/2.7/user_guide/playbooks_loops.html) for details.


## Now it's your turn!
You are in a team that is required to install the following packages to the following servers:

**Packages:**

- Apache
- Git
- FTP

**Servers:**

- ubuntu-server
- centos-server

These servers use apt and yum respectively to install packages. Make use of the when statement and looping to write a playbook to install these packages on both of the server types.

**Hints:**
Apache has the package name `httpd` on Centos and `apache2` on Ubuntu.



If you've got everything right then the tests we've written for you should pass. Run `pytest` and you should see the following when they do pass:

```

============================= test session starts ==============================
platform linux -- Python 3.7.0, pytest-4.0.0, py-1.7.0, pluggy-0.8.0
rootdir: /vols/pytest_5086, inifile:
plugins: testinfra-1.17.0
collecting ... collected 2 items                                                              

tests/test_packages_are_installed.py ..                                  [100%]

=========================== 2 passed in 1.26 seconds ===========================
```

Good Luck!!

  

Revision: 19e84cc198b8e89a524c2446a974a60e