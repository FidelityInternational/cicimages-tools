# Run Ansible

## Introduction

> Ansible is an IT automation tool. It can configure systems, deploy software, and orchestrate more advanced IT tasks such as continuous deployments or zero downtime rolling updates.
[Ansible Website](https://docs.ansible.com/ansible/latest/index.html)

Ansible is a powerful tool that removes a number of the complexities of working with remote environments and provides a number of abstractions for expressing tasks that needed be executed and how and when they should occur.

## Exercise Learning Objectives
Ansible has lots of features that you will learn about in future exercises. The aim of this exercise is simply to:
 - write your first ansible playbook which will:
    - configure a webserver and deploy a website
    - successfully pass a ready-made set of functional tests.

## Useful terms:
- Inventory - these are the hosts that the Ansible will run against. Hosts can be provided in a number of different ways. For now it is not essential to know more than this but if you're interested in finding out more [click here](http://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html)
- Playbook - The term playbook comes from sports, a playbook contains the named plays or moves that a team might execute in a game.


## Introduction to YAML
Before we go any further let's break down the anatomy of playbooks. Playbooks are written in [YAML](http://yaml.org/spec/1.2/spec.html). YAML used in playbooks typically takes the following form:
```YAML
---
# Comment
- attribute1: name
  attribute2:
    - item1_attribute1: value
    - item2_attribute1: value
```

- `---` : this denotes the start of a file and is actually optional in both YAML and Playbooks. We've used it here because it is something that
 is quite often seen in Playbooks, but is present by convention rather than requirement.
- `#` Anything following a hash symbol is a comment meant human readers. Therefore, comments are not interpreted.
- `-` a single hyphen denotes a list. Content that is on the same line and imeditately tabbed in on the following lines is a member of that list entry. In the case of the example above. the YAML consist of a single item list. That item has attributes, one of which (attribute2), is itself a list that contains 2 items.
- `attribute_name:value` entries followed by a colon `:` are called attributes, the value assigned to the attribute follows the colon. Value's can be simple values or complex entities themselves. For example 'attribute2' has a list assigned as it's value.

**Note:** YAML is white space sensitive. Data belonging to entities must be tabbed/spaced in by the same amount in order to be valid.

There is a lot more that could be said about YAML, but the above is enough for us to be able to write pretty much everything we need to write in most Ansible playbooks.

The following is an example Playbook that could be used to install a webserver.


```YAML
---
# Playbook containing a single play
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

Given what we now know about YAML, what can we say about the YAML for this PlayBook?
- 1 play: At the top level the YAML represents a single item list. This single entry, unsurprisingly, is called a play. Playbooks can include one or more plays
- `name:` An attribute called 'name' is used to name plays. In the case of our play, it is called 'Setup a webserver'.
- `tasks:` The play consists of 2 tasks. These are given in the list assigned to the tasks attribute.

We are using just a few of the attributes that Ansible provides for customising plays. If you are interested in find out about the others, take a [look here](https://docs.ansible.com/ansible/2.5/reference_appendices/playbooks_keywords.html#play). The list is a long one so don't worry about remembering everything. Do however bookmark this URL to help you with things that might come up further down the line as you get in to using Ansible more deeply.

## Exercise
**Note:** Before going any further do the following:
- `cd YOUR_CLONE_OF_THIS REPO`
- `cd ./exercises/IaC/ansible/writing_playbooks`

### Scenario
Your team of devoted and talented web developers have spent several weeks beavering away on possibly the most advanced, inspiring and responsive website ever created. They have now passed the website code over to your for deployment. The website code that your developers have provided you with can be found in the `./resources` folder.

To complete this exercise you will need to write a playbook which will take the website code your developers have provided you with and deploy it onto a webserver.

Your playbook will need to:
  - install apache2
  - ensure that the service is started and running
  - copies the files from the `./resources`resources' directory to the directory '/var/www/html' on the webserver

Because the team wants you to be sure everything is working before you tell them that you're finished, they've helpfully supplied a set of automated acceptance tests for your drive the code that you write. The tests can be found in  and read as follows:
```PYTHON
import pytest, testinfra, os, paramiko

def test_apache_installed_enabled_running(cmdopt):
    host=testinfra.get_host("paramiko://root@" + cmdopt, ssh_config="/root/.ssh/config")
    assert host.package("apache2").is_installed
    assert host.service("apache2").is_enabled
    assert host.service("apache2").is_running
    assert host.socket("tcp://0.0.0.0:80").is_listening

def test_website_deployed_(cmdopt):
    host=testinfra.get_host("paramiko://root@" + cmdopt, ssh_config="/root/.ssh/config")
    cmd=host.run('wget -qO- http://localhost/index.html')
    assert 'High Five' in cmd.stdout
```

Execute the tests by running: `pytest --ansible-host container_hostname`
**Note** We haven't built anything yet so it's fine to have run the command as it was specified.
This outputs the following:
```
============================= test session starts ==============================
platform linux2 -- Python 2.7.12, pytest-3.6.2, py-1.5.3, pluggy-0.6.0
rootdir: /vols/pytest_21755, inifile:
plugins: testinfra-1.14.0
collected 2 items

tests/webserver_test.py FF                                               [100%]

=================================== FAILURES ===================================
____________________ test_apache_installed_enabled_running _____________________

cmdopt = 'container_hostname'

    def test_apache_installed_enabled_running(cmdopt):
        host=testinfra.get_host("paramiko://root@" + cmdopt, ssh_config="/root/.ssh/config")
>       assert host.package("apache2").is_installed

tests/webserver_test.py:5: 
_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ 
/usr/local/lib/python2.7/dist-packages/testinfra/host.py:91: in __getattr__
    obj = module_class.get_module(self)
/usr/local/lib/python2.7/dist-packages/testinfra/modules/base.py:33: in get_module
    klass = cls.get_module_class(_host)
/usr/local/lib/python2.7/dist-packages/testinfra/modules/package.py:68: in get_module_class
    if host.system_info.type == "freebsd":
/usr/local/lib/python2.7/dist-packages/testinfra/modules/systeminfo.py:124: in type
    return self.sysinfo["type"]
/usr/local/lib/python2.7/dist-packages/testinfra/utils/__init__.py:42: in __get__
    value = obj.__dict__[self.func.__name__] = self.func(obj)
/usr/local/lib/python2.7/dist-packages/testinfra/modules/systeminfo.py:33: in sysinfo
    sysinfo["type"] = self.check_output("uname -s").lower()
/usr/local/lib/python2.7/dist-packages/testinfra/host.py:55: in run
    return self.backend.run(command, *args, **kwargs)
/usr/local/lib/python2.7/dist-packages/testinfra/backend/paramiko.py:101: in run
    rc, stdout, stderr = self._exec_command(command)
/usr/local/lib/python2.7/dist-packages/testinfra/backend/paramiko.py:88: in _exec_command
    chan = self.client.get_transport().open_session()
/usr/local/lib/python2.7/dist-packages/testinfra/utils/__init__.py:42: in __get__
    value = obj.__dict__[self.func.__name__] = self.func(obj)
/usr/local/lib/python2.7/dist-packages/testinfra/backend/paramiko.py:84: in client
    client.connect(**cfg)
/usr/local/lib/python2.7/dist-packages/paramiko/client.py:329: in connect
    to_try = list(self._families_and_addresses(hostname, port))
_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ 

self = <paramiko.client.SSHClient object at 0x7f2e99e9ff10>
hostname = 'container_hostname', port = 22

    def _families_and_addresses(self, hostname, port):
        """
            Yield pairs of address families and addresses to try for connecting.
    
            :param str hostname: the server to connect to
            :param int port: the server port to connect to
            :returns: Yields an iterable of ``(family, address)`` tuples
            """
        guess = True
        addrinfos = socket.getaddrinfo(
>           hostname, port, socket.AF_UNSPEC, socket.SOCK_STREAM)
E       gaierror: [Errno -2] Name or service not known

/usr/local/lib/python2.7/dist-packages/paramiko/client.py:200: gaierror
____________________________ test_website_deployed_ ____________________________

cmdopt = 'container_hostname'

    def test_website_deployed_(cmdopt):
        host=testinfra.get_host("paramiko://root@" + cmdopt, ssh_config="/root/.ssh/config")
>       cmd=host.run('wget -qO- http://localhost/index.html')

tests/webserver_test.py:12: 
_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ 
/usr/local/lib/python2.7/dist-packages/testinfra/host.py:55: in run
    return self.backend.run(command, *args, **kwargs)
/usr/local/lib/python2.7/dist-packages/testinfra/backend/paramiko.py:101: in run
    rc, stdout, stderr = self._exec_command(command)
/usr/local/lib/python2.7/dist-packages/testinfra/backend/paramiko.py:88: in _exec_command
    chan = self.client.get_transport().open_session()
/usr/local/lib/python2.7/dist-packages/testinfra/utils/__init__.py:42: in __get__
    value = obj.__dict__[self.func.__name__] = self.func(obj)
/usr/local/lib/python2.7/dist-packages/testinfra/backend/paramiko.py:84: in client
    client.connect(**cfg)
/usr/local/lib/python2.7/dist-packages/paramiko/client.py:329: in connect
    to_try = list(self._families_and_addresses(hostname, port))
_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ 

self = <paramiko.client.SSHClient object at 0x7f2e997ac710>
hostname = 'container_hostname', port = 22

    def _families_and_addresses(self, hostname, port):
        """
            Yield pairs of address families and addresses to try for connecting.
    
            :param str hostname: the server to connect to
            :param int port: the server port to connect to
            :returns: Yields an iterable of ``(family, address)`` tuples
            """
        guess = True
        addrinfos = socket.getaddrinfo(
>           hostname, port, socket.AF_UNSPEC, socket.SOCK_STREAM)
E       gaierror: [Errno -2] Name or service not known

/usr/local/lib/python2.7/dist-packages/paramiko/client.py:200: gaierror
=========================== 2 failed in 0.22 seconds ===========================
```
The output shows us that two tests attempted to verify:
1. The webserver was installed and running
2. The website in the resources folder was deployed correctly

Both of these failed because they are unable to connect to the server we specified (see the lines that in the output prefixed with 'E'). This is totally correct and makes sense given we gave an incorrect hostname and seeing as we have not yet run any ansible to build out our webserver.

### Writing a playbook
Let's create our first playbook using the the YAML we looked at earlier. Write the following YAML in to `ansible/webserver.yml`

**Note:** Playbooks can be named anything. By convention we will store them in a folder called 'ansible'.

```YAML
---
# Playbook containing a single play
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

Now execute playbook with the following command: `ansible-playbook ansible/webserver.yml`

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

[ OK ] FINISHED - start container with: cic start lvlup/ci_course:xxxxxxxxxxxxxxxx
```

> So what just happened?

Well the first thing the ansible-playbook command did was to look at `ansible/webserver.yml` and find the play defined in there.

The terminal output shows us that our 2 tasks ran:
 - installing apache2
```
 TASK [install apache2] *********************************************************
changed: [localhost]
```
 - starting apache2
```
TASK [Start service apache2, if not running] ***********************************
changed: [localhost]
```

The last line of output came from the courseware installed on your machine and gives us the ID we need to start the container up and run our tests again.
```
[ OK ] FINISHED - start container with: cic start lvlup/ci_course:xxxxxxxxxxxxxxxx
```

Using the actual ID that came out on your console, let's cic start the container that was created, run: `cic start lvlup/ci_course:xxxxxxxxxxxxxxxx`





This should output the following:
```
[OK] Starting container: lvlup-ci_course-xxxxxxxxxxxxxxxx

     connect to it with the 'cic connect' command.
     E.g. cic connect lvlup-ci_course-xxxxxxxxxxxxxxxx
     For more info run: cic help connect
     
     stop the container with the 'cic stop' command
     E.g. cic stop lvlup-ci_course-xxxxxxxxxxxxxxxx
     For more info run: cic help stop
```
Run the test again, this time however we'll point it at the container that we want to run the test against.
To do this run: `pytest --ansible-host lvlup-ci_course-xxxxxxxxxxxxxxxx`

We can see from the output that the first of the two tests is now passing telling us that Apache is now up and running.
```
============================= test session starts ==============================
platform linux2 -- Python 2.7.12, pytest-3.6.2, py-1.5.3, pluggy-0.6.0
rootdir: /vols/pytest_15279, inifile:
plugins: testinfra-1.14.0
collected 2 items

tests/webserver_test.py .F                                               [100%]

=================================== FAILURES ===================================
____________________________ test_website_deployed_ ____________________________

cmdopt = 'lvlup-ci_course-xxxxxxxxxxxxxxxx'

    def test_website_deployed_(cmdopt):
        host=testinfra.get_host("paramiko://root@" + cmdopt, ssh_config="/root/.ssh/config")
        cmd=host.run('wget -qO- http://localhost/index.html')
>       assert 'High Five' in cmd.stdout
E       assert 'High Five' in '\n<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.....\n          </p>\n        </div>\n\n\n\n\n      </div>\n    </div>\n    <div class="validator">\n    </div>\n  </body>\n</html>\n\n'
E        +  where '\n<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.....\n          </p>\n        </div>\n\n\n\n\n      </div>\n    </div>\n    <div class="validator">\n    </div>\n  </body>\n</html>\n\n' = CommandResult(command='wget -qO- http://localhost/index.html', exit_status=0, ...n    <div class="validator">\n    </div>\n  </body>\n</html>\n\n', stderr=None).stdout

tests/webserver_test.py:13: AssertionError
====================== 1 failed, 1 passed in 1.13 seconds ======================
```

The second of the tests checks that the website content being served was correct - This test failed because apache did not serve a page which contained the words 'High Five'
Now it's time to pass the 2nd of the two tests.

### Modules
Out of the box Ansible comes with a number of modules

> What's a module?

Module's are discrete units of code that are available to use either within a playbook or directly from the commandline. Ansible comes bundle with a whole bunch of them! The community has written modules for performing all sorts of different kings of task. [Take a look!](https://docs.ansible.com/ansible/devel/modules/modules_by_category.html).

We've actually already been using modules in the ansible that we wrote earlier.
```YAML
tasks:
  - name: install apache2
    apt:
      name: apache2
      update_cache: yes
      state: latest
```
in the above YAML [apt](https://docs.ansible.com/ansible/latest/modules/apt_module.html) is the module that we are instructing Ansible to use in this task. Each of the attributes supplied inside apt are supplied as parameters to the apt module. You should be able to find the documentation regarding these parameters and others on the [apt module](https://docs.ansible.com/ansible/latest/modules/apt_module.html) documentation page.

```YAML
tasks:
  - name: Start service apache2, if not running
    service:
      name: apache2
      enabled: yes
      state: started
```
> What module is used in the above task definition?

That's right, it's the [service](https://docs.ansible.com/ansible/latest/modules/service_module.html)

When it comes to copying files you find relevant modules under the [Files modules section](https://docs.ansible.com/ansible/devel/modules/list_of_files_modules.html).

The one that we are going have a try at using is the [synchronize module](https://docs.ansible.com/ansible/devel/modules/synchronize_module.html#synchronize-module).

### Now it's your turn
Add a task, using the synchronise module, to deploy the code supplied in the `./resources` directory to /var/www/html on the webserver.





You'll you've got it right when the acceptance tests pass and showing thing like the following :)

```
============================= test session starts ==============================
platform linux2 -- Python 2.7.12, pytest-3.6.2, py-1.5.3, pluggy-0.6.0
rootdir: /vols/pytest_9712, inifile:
plugins: testinfra-1.14.0
collected 2 items

tests/webserver_test.py ..                                               [100%]

=========================== 2 passed in 1.11 seconds ===========================
```

Good luck!

## Summary
Ansible playbooks contain plays and are written in [YAML](http://yaml.org/spec/1.2/spec.html).

Plays specify a group of tasks and the context in which they should be executed.

Tasks make use of modules, of which Ansible has [many](https://docs.ansible.com/ansible/devel/modules/modules_by_category.html)! Modules are wrappers around code that can be executed within your plays or on the command line via the `ansible` command.
