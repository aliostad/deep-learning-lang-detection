from Domain.rent import rent

class rent_controller():
    
    def __init__(self, repository, validator, movie_repository, client_repository):
        self.__repository = repository
        self.__validator = validator
        self.__movie_repository = movie_repository
        self.__client_repository = client_repository

    
    def createRent(self, idc, idm):

        '''Rents a movie to a client'''

        if self.__client_repository.findByID(idc) == True and self.__movie_repository.findByID(idm) == True:
            rent1 = rent(idc, idm)
            self.__validator.validate(rent1)
            self.__repository.storeRent(rent1)
            return rent1
        else:
            raise ValueError("The id of the client or movie does not exist")

    
    def getAllRents(self):

        '''Returns all rents'''

        return self.__repository.getAll()

    
    def returnMovie(self, idm):
        
        '''Sets the IsRented status of a movie to False'''

        try:
            self.__repository.returnMovie(idm)
        except ValueError as msg:
            print (msg)
    
    
    def returnBestClients(self):

        '''Returns a list of clients with rented movies, and how many movies each client rented.'''

        return self.__repository.returnBestClients()
    
    
    
        
    
    
        
    
    