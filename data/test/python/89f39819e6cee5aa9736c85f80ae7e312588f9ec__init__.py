from grano.core import app
from grano.util import jsonify

from grano.views.network_api import api as network_api
from grano.views.entity_api import api as entity_api
from grano.views.relation_api import api as relation_api
from grano.views.schema_api import api as schema_api
from grano.views.query_api import api as query_api

from grano.views.home import section as home_section
from grano.views.account import section as account_section

app.register_blueprint(network_api, url_prefix='/api/1')
app.register_blueprint(entity_api, url_prefix='/api/1')
app.register_blueprint(relation_api, url_prefix='/api/1')
app.register_blueprint(schema_api, url_prefix='/api/1')
app.register_blueprint(query_api, url_prefix='/api/1')

app.register_blueprint(account_section, url_prefix='')
app.register_blueprint(home_section, url_prefix='')

@app.route('/api/1')
def apiroot():
    return jsonify({'api': 'ok', 'version': 1})
