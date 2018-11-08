import pytest, testinfra, paramiko

def test_ubuntu_servers():
    host = testinfra.get_host("paramiko://root@ubuntu-server", ssh_config="/root/.ssh/config")
    assert host.package("git").is_installed
    assert host.package("ftp").is_installed
    assert host.package("apache2").is_installed


def test_centos_servers():
    host = testinfra.get_host("paramiko://root@centos-server", ssh_config="/root/.ssh/config")
    assert host.package("git").is_installed
    assert host.package("ftp").is_installed
    assert host.package("httpd").is_installed


