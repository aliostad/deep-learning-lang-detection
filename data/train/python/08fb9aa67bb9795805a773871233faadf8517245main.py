from repository.filmRepository.filmRepository import FilmRepository
from ui.ui import Ui
from domain.film.filmValidator import FilmValidator
from repository.clientRepository.clientRepository import ClientRepository
from domain.client.clientValidator import ClientValidator
from controller.filmController import FilmController
from controller.clientController import ClientController
from repository.rentRepository.rentRepository import RentRepository
from domain.rent.rentValidator import RentValidator
from controller.rentController import RentController

filmRepo = FilmRepository()
filmVal = FilmValidator()
clientRepo = ClientRepository()
clientVal = ClientValidator()
filmController = FilmController(filmRepo, filmVal)
rentRepo = RentRepository()
rentVal = RentValidator()
rentController = RentController(rentRepo, rentVal, filmRepo, clientRepo)
clientController = ClientController(clientRepo, clientVal)
ui = Ui(filmController, clientController, rentController, clientRepo)

ui.main()