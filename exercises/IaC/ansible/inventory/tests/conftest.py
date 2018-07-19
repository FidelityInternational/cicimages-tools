# import pytest, testinfra, paramiko
# def pytest_addoption(parser):
#     parser.addoption(
#         "--hostname", action="store"
#     )

# @pytest.fixture
# def host(request):
#     hostname=request.config.getoption("--hostname")
#     return testinfra.get_host("paramiko://root@" + hostname, ssh_config="/root/.ssh/config")