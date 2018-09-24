import pytest

testinfra_hosts = ["server2", "server3"]

def test_motd(host):
    assert host.file("/root/.bashrc").exists
    assert host.file("/root/.bashrc").contains("\(PROD\)")
