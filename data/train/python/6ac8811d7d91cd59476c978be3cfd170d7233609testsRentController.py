from repository.rentRepository.rentRepository import RentRepository
from domain.rent.rentValidator import RentValidator
from domain.rent.rent import Rent
from repository.filmRepository.filmRepository import FilmRepository
from repository.clientRepository.clientRepository import ClientRepository
from controller.rentController import RentController
from controller.filmController import FilmController
from controller.clientController import ClientController
from domain.film.filmValidator import FilmValidator
from domain.client.clientValidator import ClientValidator

def tests_rentController():
    filmRepo =FilmRepository()
    filmValid = FilmValidator()
    filmController = FilmController(filmRepo, filmValid)
    
    clientRepo = ClientRepository()
    clientValid = ClientValidator()
    clientController = ClientController(clientRepo, clientValid)
    
    filmController.createFilm("1", "blabla", "blaaa", "fantasy")
    filmController.createFilm("2", "blabla2", "blaaa2", "fantasy")
    filmController.createFilm("3", "blabla3", "blaaa3", "adventure")
    
    clientController.createClient("1", "stefan", "1234")
    clientController.createClient("2", "stefan2", "12345")
    clientController.createClient("3", "stefan3", "123456")
    
    
    
    
    repo = RentRepository()
    valid = RentValidator()
    ctrl = RentController(repo, valid, filmRepo, clientRepo)
    
    rent1 = ctrl.createRent("1", "2")
    assert len(ctrl.getAllRents()) == 1
    assert rent1.getIDC() == "1"
    assert rent1.getIDF() == "2"
    
    try:
        ctrl.createRent("3", "2")
        assert False
    except ValueError:
        assert True
        
    ctrl.returnFilm("2")
    assert ctrl.getAllRents()[0].getIsRented() == False
    
    try:
        ctrl.createRent("3", "2")
        assert True
    except ValueError:
        assert False
        
tests_rentController()
    
    
    
    