from devmine.app.controllers.assets_controller import AssetsController
from devmine.app.controllers.users_controller import UsersController
from devmine.app.controllers.features_controller import FeaturesController
from devmine.app.controllers.index_controller import IndexController
from devmine.app.controllers.github.users_controller import (
    GithubUsersController
)
from devmine.app.controllers.github.repositories_controller import (
    GithubRepositoriesController
)
from devmine.app.controllers.scores_controller import ScoresController
from devmine.app.controllers.search_controller import SearchController
from devmine.app.controllers.stats_controller import StatsController


def setup_routing(app):
    # static assets
    app.route('/favicon.ico', 'GET', AssetsController.favicon)
    app.route('/favicon.png', 'GET', AssetsController.favicon)

    # default route
    app.route('/', 'GET', IndexController().index)

    # features
    app.route('/features', 'GET', FeaturesController().index)
    app.route('/features/by_category', 'GET', FeaturesController().by_category)

    # Github users
    app.route('/github/users', 'GET', GithubUsersController().index)
    app.route('/github/users/<id:re:[0-9]+>', 'GET',
              GithubUsersController().show)
    app.route('/github/users/login/<login>', 'GET',
              GithubUsersController().login)

    # Github repositories
    app.route('/github/repositories', 'GET',
              GithubRepositoriesController().index)
    app.route('/github/repositories/<id:re:[0-9]+>', 'GET',
              GithubRepositoriesController().show)

    # scores
    app.route('/scores', 'GET', ScoresController().index)
    app.route('/scores/<id:re:[0-9]+>', 'GET', ScoresController().show)

    # search
    app.route('/search/<q>', 'GET', SearchController().query)

    # stats
    app.route('/stats', 'GET', StatsController().index)

    # users
    app.route('/users', 'GET', UsersController().index)
    app.route('/users/<id:re:[0-9]+>', 'GET', UsersController().show)
