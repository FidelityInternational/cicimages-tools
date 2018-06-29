import pytest
def pytest_addoption(parser):
    parser.addoption(
        "--ansible-host", action="store"
    )

@pytest.fixture
def cmdopt(request):
    return request.config.getoption("--ansible-host")