import pytest
import json
import urllib.request

def get(url):
    auth_user='test'
    auth_passwd='test'

    passman = urllib.request.HTTPPasswordMgrWithDefaultRealm()
    passman.add_password(None, url, auth_user, auth_passwd)
    authhandler = urllib.request.HTTPBasicAuthHandler(passman)
    opener = urllib.request.build_opener(authhandler)
    urllib.request.install_opener(opener)

    res = urllib.request.urlopen(url)
    res_body = res.read()
    return res_body.decode('utf-8')

def as_json(string):
    return json.loads(string)


def test_cluster_contains_3_nodes():
    nodes = as_json(get("http://rabbit1:15672/api/nodes"))
    assert len(nodes) == 3
