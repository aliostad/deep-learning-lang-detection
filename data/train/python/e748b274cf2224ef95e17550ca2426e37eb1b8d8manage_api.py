from flask.ext.script import Manager, Server
from yams_api.api import api
from config import API

api.config.from_object(API)
#manager_api = Manager(api, usage="API Management")
manager_api = Manager(api)


# using the flask-script Server() command was binding to the wrong Flask instance.
# this server only gets used for dev/testing, so this is 'fine'
def run_api():
    api.run(
        debug=API.DEBUG,
        host=API.LISTEN_HOST,
        port=API.LISTEN_PORT
    )


# todo: once the socket API changes are public, make this default to starting that as well
@manager_api.command
def run():
    run_api()

@manager_api.command
def run_http_only():
    run_api()