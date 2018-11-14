import pytest, testinfra, paramiko

def host():
    return testinfra.get_host("paramiko://root@web1", ssh_config="/root/.ssh/config")

def test_apache_installed():
    assert host().package("apache2").is_installed

def test_apache_is_enabled_as_service():
    assert host().service("apache2").is_enabled

def test_apache_installed_is_running():
    assert host().service("apache2").is_running
    assert host().socket("tcp://0.0.0.0:80").is_listening

