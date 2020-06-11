from Repository.rent_repository import rent_repository
from Domain.rent_validator import rent_validator
from Repository.movie_repository import movie_repository
from Repository.client_repository import client_repository
from Controller.rent_controller import rent_controller
from Controller.movie_controller import movie_controller
from Controller.client_controller import client_controller
from Domain.movie_validator import movie_validator
from Domain.client_validator import client_validator

def tests_rent_controller():
    movieRepo = movie_repository()
    movieValid = movie_validator()
    movieController = movie_controller(movieRepo, movieValid)
    
    clientRepo = client_repository()
    clientValid = client_validator()
    clientController = client_controller(clientRepo, clientValid)
    
    movie_controller.createmovie("1", "blabla", "blaaa", "fantasy")
    movie_controller.createmovie("2", "blabla2", "blaaa2", "fantasy")
    movie_controller.createmovie("3", "blabla3", "blaaa3", "adventure")
    
    client_controller.createClient("1", "gabi", "1234")
    client_controller.createClient("2", "gabi23", "12345")
    client_controller.createClient("3", "gabi3", "123456")
    
    
    
    
    repo = rent_repository()
    valid = rent_validator()
    ctrl = rent_controller(repo, valid, movieRepo, clientRepo)
    
    rent1 = ctrl.createrent("1", "2")
    assert len(ctrl.getAllrents()) == 1
    assert rent1.getIDC() == "1"
    assert rent1.getIDF() == "2"
    
    try:
        ctrl.createrent("3", "2")
        assert False
    except ValueError:
        assert True
        
    ctrl.returnmovie("2")
    assert ctrl.getAllrents()[0].getIsrented() == False
    
    try:
        ctrl.createrent("3", "2")
        assert True
    except ValueError:
        assert False
        
tests_rent_controller()
    
    
    
    