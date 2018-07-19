import pytest

def test_inventory_server1_config(host):
    inventory = host.file("ansible/inventory")
    assert inventory.contains("server1")

def test_inventory_server2_config(host):
    inventory = host.file("ansible/inventory")
    assert inventory.contains("server2")

def test_inventory_server3_config(host):
    inventory = host.file("ansible/inventory")
    assert inventory.contains("server3")