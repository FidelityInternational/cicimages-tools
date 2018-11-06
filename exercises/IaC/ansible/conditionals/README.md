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
- `cd blah`

Run `cic up` to bring up all the test infrastructure and support files required to complete this exercise. To stop and reset this infrastructure run `cic down`.

## Tutorial

### The When Statement

The When Statement defines the condition for **when** a certain action should happen.





The condition is declared within the task itself using the `when` clause. The following example declares 2 tasks:
- `Runtime requirements check` - This will fail if the `installation_dir` variable is not supplied
- `Setup runtime` - which outputs a message if the `log_level` variable is supplied.

```

---
- name: setup environment
  hosts: all
  tasks:
  - name: Runtime requirements check
    fail: msg="Required variable '{{ installation_dir }}' not set"
    when: installation_dir is undefined

  - name: Setup runtime
    shell: echo "Logging at '{{ log_level }}'"
    when: log_level is defined


```

In this example the when clause is defined using a `test`. There are many ways you can utilise tests to define your conditionals, more information can be found [here.](https://docs.ansible.com/ansible/2.5/user_guide/playbooks_tests.html)

Write this example yaml to `ansible/logic_examples.yml` so that you can try running it. Running `ansible-playbook ansible/logic_examples.yml -c local`, i.e. not supplying the required `installation_dir` causes the first of our tasks to fail:
```
PLAY [setup environment] *******************************************************

TASK [Gathering Facts] *********************************************************
ok: [127.0.0.1]

TASK [Runtime requirements check] **********************************************
fatal: [127.0.0.1]: FAILED! => {"msg": "The task includes an option with an undefined variable. The error was: 'installation_dir' is undefined\n\nThe error appears to have been in '/vols/ansible_19948/ansible/logic_examples.yml': line 5, column 5, but may\nbe elsewhere in the file depending on the exact syntax problem.\n\nThe offending line appears to be:\n\n  tasks:\n  - name: Runtime requirements check\n    ^ here\n"}
	to retry, use: --limit @/vols/ansible_19948/ansible/logic_examples.retry

PLAY RECAP *********************************************************************
127.0.0.1                  : ok=1    changed=0    unreachable=0    failed=1   
```

We can fix this by supplying the `installation_dir` using the the `--extra-vars` option. I.e run `ansible-playbook ansible/logic_examples.yml -c local --extra-vars='installation_dir=/var'`
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

You'll notice that this time the playbook executed successfully but that the `Setup runtime` task did not execute. This is because we did not supply the optional `log_level` variable. Run: `ansible-playbook ansible/logic_examples.yml -c local --extra-vars='installation_dir=/var log_level=debug'` to see the `Setup runtime`
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



To combine multiple conditions you can make use of 'or' and 'and', where the play will execute if one of the conditions is met, or if both of the conditions are met, respectively.

Rewrite your file to `ansible/logic_examples.yml` with the following yaml so that you can try running it:

```

---
- name: Global working hours
  hosts: all
  vars:
    day: Saturday
    time: 17:00

  tasks:
  - debug:
      msg: "No one will be available globally in the office till Monday 01:00 GMT"
    when: day=="Saturday" or day=="Sunday"

```

Running `ansible-playbook ansible/logic_examples.yml -c local`, will print the statement as one of the two conditions are met.

```
PLAY [Global working hours] ****************************************************

TASK [Gathering Facts] *********************************************************
ok: [127.0.0.1]

TASK [debug] *******************************************************************
ok: [127.0.0.1] => {
    "msg": "No one will be available globally in the office till Monday 01:00 GMT"
}

PLAY RECAP *********************************************************************
127.0.0.1                  : ok=2    changed=0    unreachable=0    failed=0   

[ OK ] FINISHED - start container with: cic start cic_container-xxxxxxxxxxxxxxxx
```

Alternatively, we can require both conditions to be met. Overwrite your yaml, `ansible/logic_examples.yml`, with the following yaml:

```

---
- name: Global working hours
  hosts: all
  vars:
    day: Monday
    time: 17:00

  tasks:
  - debug:
      msg: "No one will be available globally in the office till 01:00 GMT"
    when: day=="Monday" and time>=5

```

Running `ansible-playbook ansible/logic_examples.yml -c local`, will now print an alternative message for a weekday that indicates no one will be in the office till the following morning.

```
PLAY [Global working hours] ****************************************************

TASK [Gathering Facts] *********************************************************
ok: [127.0.0.1]

TASK [debug] *******************************************************************
ok: [127.0.0.1] => {
    "msg": "No one will be available globally in the office till 01:00 GMT"
}

PLAY RECAP *********************************************************************
127.0.0.1                  : ok=2    changed=0    unreachable=0    failed=0   

[ OK ] FINISHED - start container with: cic start cic_container-xxxxxxxxxxxxxxxx
```
### Exercise


You are in a team that is required to install Apache on a selection of servers. These servers all have different operating systems. Make use of the when statement and looping to write a playbook that iterates through the servers and installs Apache in the corresponding manner.

**Hints:**
Apache has a different package name in Ubuntu and CentOS.



If you've got everything right then the tests we've written for you should pass. Run `pytest` and you should see the following when they do pass:
```
============================= test session starts ==============================
platform linux -- Python 3.7.0, pytest-3.8.2, py-1.6.0, pluggy-0.7.1
rootdir: /vols/pytest_21985, inifile:
plugins: testinfra-1.16.0

collecting 0 items                                                             
collecting 2 items                                                             
collected 2 items                                                              

tests/test_a_test.py ..                                                  [100%]

=========================== 2 passed in 1.30 seconds ===========================
```

  

Revision: a1c7eea5dfc0b901ef995bcf7c408125