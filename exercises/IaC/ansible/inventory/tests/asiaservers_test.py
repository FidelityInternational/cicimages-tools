import pytest

testinfra_hosts = ["server2", "server3"]

def test_motd(host):
    assert host.file("/etc/issue").exists
    assert host.file("/etc/issue").contains("Region:\s*asia")
