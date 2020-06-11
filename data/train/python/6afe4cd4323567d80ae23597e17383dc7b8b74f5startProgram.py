from Repository.clientRepository import clientRepository
from Domain.Validator import clientValidator, movieValidator
from Controller.Controller import clientController, movieController, rentController
from UI.Console import Console
from Repository.movieRepository import movieRepository
from Repository.rentRepository import rentRepository

clientRepo = clientRepository()
clientValidator = clientValidator()
movieRepo = movieRepository()
movieValidator = movieValidator()
rentRepo = rentRepository()
clientController = clientController(clientRepo, clientValidator)
movieController = movieController(movieRepo, movieValidator)
rentController = rentController(rentRepo)
ui = Console(clientController, movieController, rentController)

ui.showUI()