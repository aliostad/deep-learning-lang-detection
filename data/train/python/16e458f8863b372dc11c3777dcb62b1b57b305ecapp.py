from repository.filmRepository.filmRepository import FilmRepository, FilmFileRepository
from ui.ui import Ui
from domain.film.filmValidator import FilmValidator
from repository.clientRepository.clientRepository import ClientRepository, ClientFileRepository
from domain.client.clientValidator import ClientValidator
from controller.filmController import FilmController
from controller.clientController import ClientController
from repository.rentRepository.rentRepository import RentRepository
from domain.rent.rentValidator import RentValidator
from controller.rentController import RentController

filmRepo = FilmFileRepository("films.txt")
filmVal = FilmValidator()
clientRepo = ClientFileRepository("clients.txt")
clientVal = ClientValidator()
filmController = FilmController(filmRepo, filmVal)
rentRepo = RentRepository()
rentVal = RentValidator()
rentController = RentController(rentRepo, rentVal, filmRepo, clientRepo)
clientController = ClientController(clientRepo, clientVal)
ui = Ui(filmController, clientController, rentController)

ui.main()