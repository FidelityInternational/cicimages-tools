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
