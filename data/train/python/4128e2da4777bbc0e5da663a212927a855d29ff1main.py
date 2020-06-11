from Tests import runTest
from Controller import *
from Domain import *
from Repository import *
from Repository.file_repository import client_file
from Repository.file_repository import movie_file
from Repository.file_repository import rent_file
from Validators import *
from UI.UI import UI


movie_repository = movie_repository.movie_repository()
movie_validator = movie_validator.movie_validator()
client_repository = client_repository.client_repository()
client_validator = client_validator.client_validator()
rent_repository = rent_repository.rent_repository()
rent_validator = rent_validator.rent_validator()
clients_file = client_file("clients.txt", client_repository)
movies_file = movie_file("movies.txt", movie_repository)
rents_file = rent_file("rents.txt", rent_repository)

client_l = clients_file.loadFromFile()
movie_l = movies_file.loadFromFile()
rent_l = rents_file.loadFromFile()

movie_controller = movie_controller.movie_controller(movie_repository, movie_validator)
client_controller = client_controller.client_controller(client_repository, client_validator)
rent_controller = rent_controller.rent_controller(rent_repository, rent_validator, movie_repository, client_repository)

ui = UI(client_controller, movie_controller, rent_controller, clients_file, movies_file, rents_file)


ui.main()