from flask import (Flask)

from controller.class_controller import class_controller
from controller.game_controller import game_controller
from controller.gamehistory_controller import gamehistory_controller
from controller.player_controller import player_controller
from controller.team_controller import team_controller

import settings

app = Flask(__name__)
app.debug = settings.DEBUG

app.register_blueprint(class_controller)
app.register_blueprint(game_controller)
app.register_blueprint(gamehistory_controller)
app.register_blueprint(player_controller)
app.register_blueprint(team_controller)

if __name__ == "__main__":
    app.run(host='0.0.0.0')
