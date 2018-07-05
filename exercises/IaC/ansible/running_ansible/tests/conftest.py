import pytest, testinfra, paramiko
def pytest_addoption(parser):
    parser.addoption(
        "--ansible-host", action="store"
    )

@pytest.fixture
def host(request):
    hostname=request.config.getoption("--ansible-host")
    return testinfra.get_host("paramiko://root@" + hostname, ssh_config="/root/.ssh/config")