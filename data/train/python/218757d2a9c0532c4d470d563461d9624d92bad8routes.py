from src import app, api
from flask import render_template
from api.import_captions import ImportCaptions as ImportCaptionsApi
from api.import_episodes import ImportEpisodes as ImportEpisodesApi
from api.search import Search as SearchApi
from api.captions import Captions as CaptionsApi
from api.episode import Episodes as EpisodesApi

# Data
api.add_resource(ImportEpisodesApi, '/api/import/episodes/<string:series>/')
api.add_resource(ImportCaptionsApi, '/api/import/captions/<string:series>/')

# API
api.add_resource(EpisodesApi, '/api/episodes/<string:series>/')
api.add_resource(SearchApi, '/api/search/<string:series>/')
api.add_resource(CaptionsApi, '/api/captions/<string:series>/<string:episode>')

# Site
@app.route('/', methods=['GET', 'HEAD'])
def landing():
    """Show landing page"""
    return render_template('index.html')

@app.route('/', defaults={'path': ''})
@app.route('/<path:path>')
def catch_all(path):
    #return 'You want path: %s' % path
    return render_template('index.html')
    #return app.send_static_file('index.html')