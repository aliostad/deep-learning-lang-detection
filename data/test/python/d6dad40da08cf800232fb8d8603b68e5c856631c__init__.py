from flask import Flask
from flask.ext.restful import Api

app = Flask(__name__)

api = Api(app)

app.config.from_object('emonitor.config.Config')

from emonitor.modules.api.job import JobListApi
from emonitor.modules.api.job import JobApi
from emonitor.modules.api.job import JobOembedApi
from emonitor.modules.api.job import JobThumbnailApi
api.add_resource(JobListApi, '/api/job')
api.add_resource(JobApi, '/api/job/<job_id>')
api.add_resource(JobOembedApi, '/api/job/oembed')
api.add_resource(JobThumbnailApi, '/api/job/thumbnail/<job_id>/<frame>')


from emonitor.modules.api.job import BitcoinApi
from emonitor.modules.api.job import BitcoinCallbackApi
from emonitor.modules.api.job import BitcoinCheckApi
api.add_resource(BitcoinApi, '/api/bitcoin')
api.add_resource(BitcoinCallbackApi, '/api/bitcoin/callback/<bid>/<int:secret>')
api.add_resource(BitcoinCheckApi, '/api/bitcoin/<bid>')

from emonitor.modules.main import main
app.register_blueprint(main)

