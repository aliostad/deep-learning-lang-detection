from Repository.movie_repository import movie_repository
from Ui.ui import Ui
from Domain.movie_validator import movie_validator
from Repository.client_repository import client_repository
from Domain.client_validator import client_validator
from Controller.movie_controller import movie_controller
from Controller.client_controller import client_controller
from Repository.rent_repository import rent_repository
from Domain.rent_validator import rent_validator
from Controller.rent_controller import rent_controller
from Tests import runTests

movieRepo = movie_repository
#movieRepo = movieFileRepository("movies.txt")
movieVal = movie_validator
clientRepo = client_repository
#clientRepo = ClientFileRepository("clients.txt")
clientVal = client_validator()
movie_controller = movie_controller(movieRepo, movieVal)
rentRepo = rent_repository()
rentVal = rent_validator()
rent_controller = rent_controller(rentRepo, rentVal, movieRepo, clientRepo)
client_controller = client_controller(clientRepo, clientVal)
ui = Ui(movie_controller, client_controller, rent_controller)

ui.main()