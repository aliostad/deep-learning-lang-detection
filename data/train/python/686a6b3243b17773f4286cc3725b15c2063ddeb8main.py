from ui.UI import *
from repository.Repository import *
from controller.ClientController import *
from controller.MovieController import *
from controller.RentalController import *
from domain.Movie import *
from domain.Client import *
from domain.Rental import *

clientRepository = Repository()
clientValidator = ClientValidator()
clientController = ClientController(clientRepository, clientValidator)

movieRepository = Repository()
movieValidator = MovieValidator()
movieController = MovieController(movieRepository, movieValidator)

rentalRepository = Repository()
rentalValidator = RentalValidator()
rentalController = RentalController(rentalRepository, rentalValidator)

clientController.create("1", "Ionut")
clientController.create("2", "Chubaca")
clientController.create("3", "Luke")
clientController.create("4", "Vader")
clientController.create("5", "Yoda")
clientController.create("6", "Anachin")
clientController.create("7", "Obi Wan Kenobi")


movieController.create("1", "Inelu Stapanilor", "Film despre stapani si un inel", "Drama")
movieController.create("2", "Inelu Stapanilor", "Film despre stapani si un inel", "Drama")
movieController.create("3", "Inelu Stapanilor", "Film despre stapani si un inel", "Drama")
movieController.create("4", "Inelu Stapanilor", "Film despre stapani si un inel", "Drama")
movieController.create("5", "Inelu Stapanilor", "Film despre stapani si un inel", "Drama")
movieController.create("6", "Inelu Stapanilor", "Film despre stapani si un inel", "Drama")
movieController.create("7", "Inelu Stapanilor", "Film despre stapani si un inel", "Drama")
movieController.create("8", "Inelu Stapanilor", "Film despre stapani si un inel", "Drama")
movieController.create("9", "Inelu Stapanilor", "Film despre stapani si un inel", "Drama")
movieController.create("10", "Inelu Stapanilor", "Film despre stapani si un inel", "Drama")
movieController.create("11", "Inelu Stapanilor", "Film despre stapani si un inel", "Drama")
movieController.create("12", "Inelu Stapanilor", "Film despre stapani si un inel", "Drama")



ui = UI(movieController, rentalController, clientController)
ui.mainMenu()
