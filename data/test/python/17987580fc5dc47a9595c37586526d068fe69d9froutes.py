from pydeo.app.controllers.assets_controller import AssetsController
from pydeo.app.controllers.errors_controller import ErrorsController
from pydeo.app.controllers.files_controller import FilesController
from pydeo.app.controllers.index_controller import IndexController
from pydeo.app.controllers.movies_controller import MoviesController
from pydeo.app.controllers.music_controller import MusicController
from pydeo.app.controllers.series_controller import SeriesController
from pydeo.app.controllers.settings_controller import SettingsController

from pydeo.app.controllers.api.movies_api import MoviesAPIController


def setup_routing(app):
    # static files
    app.route('/img/<filename>', 'GET', AssetsController.img)
    app.route('/js/<filename>', 'GET', AssetsController.js)
    app.route('/js/lib/<filename>', 'GET', AssetsController.js_lib)
    app.route('/css/<filename>', 'GET', AssetsController.css)
    app.route('/css/lib/<filename>', 'GET', AssetsController.css_lib)
    app.route('/css/lib/font/<filename>', 'GET', AssetsController.css_lib_font)
    app.route('/css/fonts/<filename>', 'GET', AssetsController.css_fonts)
    app.route('/swf/<filename>', 'GET', AssetsController.swf)
    app.route('/favicon.ico', 'GET', AssetsController.favicon)
    app.route('/favicon.png', 'GET', AssetsController.favicon)
    app.route('/files/movies/<filename>', 'GET', FilesController.movies)

    # errors
    app.route('/error/404', 'GET', ErrorsController().error_404)
    app.route('/error/500', 'GET', ErrorsController().error_500)

    # home
    app.route('/', 'GET', IndexController().index)

    # music
    app.route('/music', 'GET', MusicController().index)

    # movies
    app.route('/movies', 'GET', MoviesController().index)
    app.route('/movies/<id>', 'GET', MoviesController().movie)
    app.route('/movies/<id>/play', 'GET', MoviesController().play)

    # series
    app.route('/series', 'GET', SeriesController().index)

    # settings
    app.route('/settings', 'GET', SettingsController().index)

    # REST API routes
    # movies
    app.route('/api/movies', 'GET', MoviesAPIController().movies)
    app.route('/api/movies/fetch', 'GET', MoviesAPIController().movies_fetch)
    app.route('/api/movies/reload', 'GET', MoviesAPIController().movies_reload)
    app.route('/api/movies/title', 'GET', MoviesAPIController().movies_title)
    app.route('/api/movies/<id>', 'GET', MoviesAPIController().movies_id)
