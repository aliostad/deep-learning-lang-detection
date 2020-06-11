from flask import Flask, render_template
from flask.ext.sqlalchemy import SQLAlchemy
from flask.ext.login import LoginManager
from flask.ext import restful

# Setup application
app = Flask(__name__)
app.config.from_object('config')

# Flask-Login
login_manager = LoginManager()
login_manager.init_app(app)

# Setup database
db = SQLAlchemy(app)

# Handle errors
@app.errorhandler(404)
def not_found(error):
    return render_template('404.html'), 404

# Restful API
api = restful.Api(app)

# Add API resources. Use register functions so we can
# keep everything localized to modules
from .user.api import register_api as register_api_user
register_api_user(api)

from .person.api import register_api as register_api_person
register_api_person(api)

from .event.api import register_api as register_api_event
register_api_event(api)

from .item.api import register_api as register_api_item
register_api_item(api)


# Add Blueprints to application
from .interface.views import mod as interface_mod
app.register_blueprint(interface_mod)
