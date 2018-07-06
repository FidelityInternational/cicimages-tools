# Writing a PlayBook

## Introduction

> Ansible is an IT automation tool. It can configure systems, deploy software, and orchestrate more advanced IT tasks such as continuous deployments or zero downtime rolling updates.
[Ansible Website](https://docs.ansible.com/ansible/latest/index.html)

Ansible is a powerful tool that removes a number of the complexities of working with remote environments and provides a number of abstractions for expressing tasks that needed be executed and how and when they should occur.

## Exercise Learning Objectives
- Introduce
 - YAML
 - Playbooks
 - Modules
 - Write your first ansible playbook

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

- `---` : this denotes the start of a file and is actually optional in both YAML and Playbooks. We've used it here because it is something that's often seen, but is present by convention rather than requirement.
- `#` Anything following a hash symbol is a comment meant for human readers. Comments are not interpreted.
- `-` a single hyphen denotes a list. Content that is on the same line and imeditately tabbed in on the following lines is a member of that list entry. In the case of the example above. the YAML consist of a single item list. That item has attributes, one of which (attribute2), is itself a list that contains 2 items.
- `attribute_name: value` entries followed by a colon `:` are called attributes, the value assigned to the attribute follows the colon. Value's can be simple values or complex entities themselves. For example 'attribute2' has a list assigned as it's value.

**Note:** YAML is white space sensitive.

There is a lot more that could be said about YAML, but the above is enough for us to be able to write pretty much everything we need to write in most Ansible playbooks.

## Anatomy of Playbook
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

What can we say about the YAML for this PlayBook?
- It contains a singe play: The YAML represents a single item list. This single entry, unsurprisingly, is called a play. Playbooks can include one or more plays
- `name:` An attribute called 'name' is used to name plays. In the case of our play, it is called 'Setup a webserver'.
- `tasks:` The play consists of 2 tasks. These are given in the list assigned to the tasks attribute.

We are using just a few of the attributes that Ansible provides for customising plays. If you are interested in find out about the others, take at the [ansible docs for playbook keywords](https://docs.ansible.com/ansible/2.5/reference_appendices/playbooks_keywords.html#play). The list is a long one so don't worry about remembering everything.

## Exercise
**Note:** Before going any further do the following:
- `cd YOUR_CLONE_OF_THIS REPO`
- `source .env
- `cd ./exercises/IaC/ansible/writing_playbooks`

### Scenario
Your team of devoted and talented web developers have spent several weeks beavering away on possibly the most advanced, inspiring and responsive website ever created. They have now passed the website code over to your for deployment. The website code that your developers have provided you with can be found in the `./resources` folder.

To complete this exercise you will need to write a playbook which will take the website code your developers have provided and deploy it onto a webserver.

Your playbook will need to:
  - install apache2
  - ensure that the service is started and running
  - copies the files from the `./resources`resources' directory to the directory '/var/www/html' on the webserver

Because the team wants you to be sure everything is working before you tell them that you're finished, they've helpfully supplied a set of automated acceptance tests for your drive the code that you write. The tests can be found in .

Execute the tests by running: `pytest --hostname unavailable_host`
**Note** We haven't built anything yet so it's fine to have run the command as it was specified.
This outputs the following:
```
============================= test session starts ==============================
platform linux2 -- Python 2.7.12, pytest-3.6.2, py-1.5.3, pluggy-0.6.0 -- /usr/bin/python
cachedir: .pytest_cache
rootdir: /vols/pytest_8357, inifile: pytest.ini
plugins: testinfra-1.14.0
collecting ... collected 4 items

tests/webserver_test.py::test_apache_installed FAILED                    [ 25%]
tests/webserver_test.py::test_apache_is_enabled_as_service FAILED        [ 50%]
tests/webserver_test.py::test_apache_installed_is_running FAILED         [ 75%]
tests/webserver_test.py::test_website_deployed FAILED                    [100%]

=================================== FAILURES ===================================
____________________________ test_apache_installed _____________________________

host = <testinfra.host.Host object at 0x7fb79ddb8210>

    def test_apache_installed(host):
>       assert host.package("apache2").is_installed

tests/webserver_test.py:4: 
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

self = <paramiko.client.SSHClient object at 0x7fb79ddc5290>
hostname = 'unavailable_host', port = 22

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
______________________ test_apache_is_enabled_as_service _______________________

host = <testinfra.host.Host object at 0x7fb79ddb8210>

    def test_apache_is_enabled_as_service(host):
>       assert host.service("apache2").is_enabled

tests/webserver_test.py:7: 
_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ 
/usr/local/lib/python2.7/dist-packages/testinfra/host.py:91: in __getattr__
    obj = module_class.get_module(self)
/usr/local/lib/python2.7/dist-packages/testinfra/modules/base.py:33: in get_module
    klass = cls.get_module_class(_host)
/usr/local/lib/python2.7/dist-packages/testinfra/modules/service.py:51: in get_module_class
    if host.system_info.type == "linux":
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

self = <paramiko.client.SSHClient object at 0x7fb79dd8d590>
hostname = 'unavailable_host', port = 22

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
_______________________ test_apache_installed_is_running _______________________

host = <testinfra.host.Host object at 0x7fb79ddb8210>

    def test_apache_installed_is_running(host):
>       assert host.service("apache2").is_running

tests/webserver_test.py:10: 
_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ 
/usr/local/lib/python2.7/dist-packages/testinfra/host.py:91: in __getattr__
    obj = module_class.get_module(self)
/usr/local/lib/python2.7/dist-packages/testinfra/modules/base.py:33: in get_module
    klass = cls.get_module_class(_host)
/usr/local/lib/python2.7/dist-packages/testinfra/modules/service.py:51: in get_module_class
    if host.system_info.type == "linux":
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

self = <paramiko.client.SSHClient object at 0x7fb79d6fd390>
hostname = 'unavailable_host', port = 22

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
____________________________ test_website_deployed _____________________________

host = <testinfra.host.Host object at 0x7fb79ddb8210>

    def test_website_deployed(host):
>       cmd=host.run('wget -qO- http://localhost/index.html')

tests/webserver_test.py:14: 
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

self = <paramiko.client.SSHClient object at 0x7fb79d709cd0>
hostname = 'unavailable_host', port = 22

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
=========================== 4 failed in 0.27 seconds ===========================
```
The output shows us that two tests attempted to verify:
- the apache2 package was installed.
- the apache2 daemon had been started
- the apache2 process is running
- the website is being served. I.e. the resources have been deployed correctly.

All of these fail because they are unable to connect to the server we specified as we are yet to build it. (see the lines that in the output prefixed with 'E').

### Writing a playbook
Let's create our first playbook using the the YAML we looked at earlier. Write the following YAML in to `ansible/webserver.yml`

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

**Note:** Playbooks can be named anything. By convention we will store them in a folder called 'ansible'.


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

Using the actual ID that came out on your console, cic start the container that was created, this time we'll also make the webserver port 80 available locally as port 8080, run: `cic start lvlup/ci_course:xxxxxxxxxxxxxxxx --map-port 8080:80`





This should output the following:
```

```
Run the test again, this time however we'll point it at the host that we want to run the test against.
To do this run: `pytest --host `

We can see from the output that the tests verifying apache2 is installed, up and running are passing.
```

```

The remaining tests is checking that the website content being served is correct. Currently we have not done anything to deploy the team's site. Take a look at [http://localhost:8080](http://localhost:8080) and you'll see that apache is still serving the default page that you get when it apache is installed.

### Modules
Out of the box Ansible comes with a number of modules

Module's are discrete units of code that are available to use either within a playbook or directly from the commandline. Ansible comes bundled with a whole bunch of them! The community has written modules for performing all sorts of different kings of task. [Take a look!](https://docs.ansible.com/ansible/devel/modules/modules_by_category.html).

We've already been using modules in the ansible we wrote earlier.
```YAML
tasks:
  - name: install apache2
    apt:
      name: apache2
      update_cache: yes
      state: latest
```
in the above YAML [apt](https://docs.ansible.com/ansible/latest/modules/apt_module.html) is the module that we are instructing ansible to use. Each of the attributes supplied inside the declaration of 'apt:' are supplied as parameters to the apt module. You find the documentation regarding these parameters and others on the [apt module](https://docs.ansible.com/ansible/latest/modules/apt_module.html) documentation page.

```YAML
tasks:
  - name: Start service apache2, if not running
    service:
      name: apache2
      enabled: yes
      state: started
```
The other module we've used is the [service](https://docs.ansible.com/ansible/latest/modules/service_module.html) module.

When it comes to copying files you find relevant modules under the [Files modules section](https://docs.ansible.com/ansible/devel/modules/list_of_files_modules.html).

The one that we are going try is the [synchronize module](https://docs.ansible.com/ansible/devel/modules/synchronize_module.html#synchronize-module).

### Now it's your turn
Add a task, using the synchronise module, to deploy the code supplied in the `./resources` to `/var/www/html` on the webserver.



You'll know that you've got it right when the acceptance tests pass :)

```
============================= test session starts ==============================
platform linux2 -- Python 2.7.12, pytest-3.6.2, py-1.5.3, pluggy-0.6.0 -- /usr/bin/python
cachedir: .pytest_cache
rootdir: /vols/pytest_15878, inifile: pytest.ini
plugins: testinfra-1.14.0
collecting ... collected 4 items

tests/webserver_test.py::test_apache_installed PASSED                    [ 25%]
tests/webserver_test.py::test_apache_is_enabled_as_service PASSED        [ 50%]
tests/webserver_test.py::test_apache_installed_is_running PASSED         [ 75%]
tests/webserver_test.py::test_website_deployed PASSED                    [100%]

=========================== 4 passed in 1.08 seconds ===========================
```

Good luck!

## Summary
Ansible playbooks contain plays and are written in [YAML](http://yaml.org/spec/1.2/spec.html).

Plays specify a group of tasks and the context in which they should be executed.

Tasks make use of modules, of which Ansible has [many](https://docs.ansible.com/ansible/devel/modules/modules_by_category.html)!
Modules are wrappers around code that can be executed within your plays or on the command line via the `ansible` command.

You have just learned how to:
- write a playbook.
- use the ansible documentation to find out about different modules.
- use the [synchronize module](https://docs.ansible.com/ansible/devel/modules/synchronize_module.html#synchronize-module) to copy the contents of a folder from one place to another.
- write code to satisfy a condition within a set of tests.
- put more funny cats onto the Internet
