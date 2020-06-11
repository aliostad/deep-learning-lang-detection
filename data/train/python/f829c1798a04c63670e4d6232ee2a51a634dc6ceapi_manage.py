#!/usr/bin/env python

import flask_migrate
import flask_script

from seabus.common.database import db
from seabus.api.api import create_app as create_api_app

api_app = create_api_app('Dev')

api_manager = flask_script.Manager(api_app)

@api_manager.command
def apidev():
    api_app.run(
        host='0.0.0.0',
        port=6000,
        debug=True,
        use_reloader=True,
    ) 

@api_manager.command
def apiprod():
    api_app.config.from_object('seabus.api.config.Prod')
    api_app.run(
        port=6000,
    )

if __name__ == '__main__':
    api_manager.run()
