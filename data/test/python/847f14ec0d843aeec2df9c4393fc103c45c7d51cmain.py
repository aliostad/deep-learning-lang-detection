from store.controller.RentReturnController import RentReturnController
from store.controller.StatsController import StatsController
from store.domain.Validators.RentReturnValidator import RentReturnValidator
from store.repository.file_repository import MovieFileRepository, RentFileRepository, ClientFileRepository

__author__ = 'victor'

from store.controller.ClientController import ClientController
from store.controller.MovieController import MovieController
from store.ui.Console import Console
from store.domain.Validators.ClientValidator import ClientValidator
from store.domain.Validators.MovieValidator import MovieValidator


class App(object):
  @classmethod
  def main(cls):
    """Set up the app
    """
    movie_repo = MovieFileRepository(MovieValidator(),
                                     "/Users/victor/Github/MovieRental/data/movies")
    client_repo = ClientFileRepository(ClientValidator(),
                                       "/Users/victor/Github/MovieRental/data/clients")
    rent_return_repo = RentFileRepository(RentReturnValidator(),
                                          "/Users/victor/Github/MovieRental/data/rents")

    movie_controller = MovieController(movie_repo)
    client_controller = ClientController(client_repo)
    rent_return_controller = RentReturnController(rent_return_repo, client_repo, movie_repo)
    stats_controller = StatsController(rent_return_repo, client_repo, movie_repo)

    console = Console(movie_controller, client_controller, rent_return_controller, stats_controller)
    console.run_ui()


if __name__ == '__main__':
  App.main()