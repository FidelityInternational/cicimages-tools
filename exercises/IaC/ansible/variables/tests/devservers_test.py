import pytest, testinfra


def define_server_test(server, app_env):

    def _function():
        host = testinfra.get_host("paramiko://root@" + server, ssh_config="/root/.ssh/config")
        app_id_path = '/etc/app.id'
        assert host.file(app_id_path).exists
        assert host.file(app_id_path).content_string.strip() == f"CIC_WEBAPP:{app_env}:{server}"

    return _function


servers = {'dev-app1': 'DEV', 'dev-app2' : 'DEV', 'prod-app1' : 'PROD', 'prod-app2' : 'PROD'}

for server, app_env in servers.items():

    exec(f"test_{server.replace('-','_')}_server = define_server_test('{server}', '{app_env}')")

