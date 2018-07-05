import pytest

def test_apache_installed(host):
    assert host.package("apache2").is_installed

def test_apache_is_enabled_as_service(host):
    assert host.service("apache2").is_enabled

def test_apache_installed_is_running(host):
    assert host.service("apache2").is_running
    assert host.socket("tcp://0.0.0.0:80").is_listening

