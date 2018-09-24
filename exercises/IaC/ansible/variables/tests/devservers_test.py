import pytest

testinfra_hosts = ["server1"]

def test_motd(host):
    assert host.file("/root/.bashrc").exists
    assert host.file("/root/.bashrc").contains("\(DEV\)")
