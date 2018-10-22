import pytest
import urllib.request

def get(url):
    return urllib.request.urlopen(url).read().decode('utf-8')

def test_jetty_server_available():
    assert "Jetty" in get("http://jetty-server:8080"), "expected content from Jetty server"

def test_tomcat_server_available():
    assert 'Tomcat' in get("http://tomcat-server:8080"), "expected content from Tomcat server"