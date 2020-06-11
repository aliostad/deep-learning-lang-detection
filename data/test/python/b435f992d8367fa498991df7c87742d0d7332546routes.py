from Server.Controller.start_game_controller import StartGameController
from Server.Controller.get_game_controller import GetGameController
from Server.Controller.guess_controller import GuessController
from Server.Controller.start_next_round_controller import StartNextRoundController

from kao_flask.endpoint import Endpoint
from kao_flask.controllers.html_controller import HTMLController

routes = [Endpoint('/', get=HTMLController('Server/templates/index.html')),
          Endpoint('/api/startgame', post=StartGameController()),
          Endpoint('/api/<int:gameId>', get=GetGameController()),
          Endpoint('/api/<int:gameId>/guess', put=GuessController()),
          Endpoint('/api/<int:gameId>/nextround', put=StartNextRoundController())]