#!/usr/bin/env python
""":mod:`irianas_client.main` -- Program entry point
"""
import sys
sys.path[0:0] = [""]
import os
from OpenSSL import SSL
from flask import Flask
from flask.ext import restful
from irianas_client.api.api_services import \
    (ApacheServiceAPI, MySQLServiceAPI, vsFTPServiceAPI, BINDServiceAPI,
     ApacheConfigAPI, MySQLConfigAPI, BINDConfigAPI, vsFTPConfigAPI,
     SSHDServiceAPI, SSHDConfigAPI)
from irianas_client.api.api_task_basic import \
    (TaskBasicAPI, ConnectAPI, ClientInfoAPI)

api_services = '/api/services/'
api_services_conf = '/api/services/conf/'
api_task = '/api/task/'

debug = False
path = None

if 'VIRTUAL_ENV' in os.environ:
    path = os.path.join(os.environ['VIRTUAL_ENV'], 'ssl-demo')
    debug = True
else:
    path = '/etc/ssl/certs/'
    debug = False

try:
    context = SSL.Context(SSL.SSLv23_METHOD)
    context.use_privatekey_file(os.path.join(path, 'server.key'))
    context.use_certificate_file(os.path.join(path, 'server.crt'))
except SSL.Error:
    context = None


def main():
    app = Flask(__name__)
    api = restful.Api(app)
    # Apache API SSHDConfigAPI
    api.add_resource(ApacheServiceAPI, api_services + 'apache/<string:action>',
                     api_services + 'apache')

    api.add_resource(ApacheConfigAPI, api_services_conf + 'apache')

    # SSHD API
    api.add_resource(SSHDServiceAPI, api_services + 'ssh/<string:action>',
                     api_services + 'ssh')

    api.add_resource(SSHDConfigAPI, api_services_conf + 'ssh')

    # MySQL API
    api.add_resource(MySQLServiceAPI, api_services + 'mysql/<string:action>',
                     api_services + 'mysql')

    api.add_resource(MySQLConfigAPI, api_services_conf + 'mysql')

    # vsFTPD API
    api.add_resource(vsFTPServiceAPI, api_services + 'vsftpd/<string:action>',
                     api_services + 'vsftpd')

    api.add_resource(vsFTPConfigAPI, api_services_conf + 'vsftpd')

    # BIND API
    api.add_resource(BINDServiceAPI, api_services + 'bind/<string:action>',
                     api_services + 'bind')

    api.add_resource(BINDConfigAPI, api_services_conf + 'bind')

    # Basic Task API
    api.add_resource(TaskBasicAPI, api_task + '<string:action>')
    api.add_resource(ClientInfoAPI, api_task + 'info')

    # Connection API
    api.add_resource(ConnectAPI, '/api/connect')

    app.config.update(
        DEBUG=True,
        PROPAGATE_EXCEPTIONS=True
    )

    app.run(debug=debug, ssl_context=context, port=9000, host='0.0.0.0',
            threaded=True)

if __name__ == '__main__':
    main()
