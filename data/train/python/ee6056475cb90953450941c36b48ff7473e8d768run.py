from werkzeug.serving import run_simple
from werkzeug.wsgi import DispatcherMiddleware

#imports apps
from app import admin,api

#create main app
admin_app = admin.create_app()

api = api.create_app()

from app.api.database import module as mongo_api
from app.api.local import module as local_api

api.register_blueprint(mongo_api)
api.register_blueprint(local_api)

application = DispatcherMiddleware(admin_app,{
	'/api':api
})

if __name__ == '__main__':
	run_simple('127.0.0.1',4444,application,use_reloader=True,use_debugger=True)
