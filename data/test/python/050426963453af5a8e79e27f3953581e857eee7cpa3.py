from movielib.model import schema
from movielib.view import TextMovieView
from movielib.controller import MovieController
import MyMovie
import MovieText
import MyDatabase
import sys
def main():
    # load movies
    db = MyDatabase.MyDatabase(MovieText.MovieText('movies.txt'), schema, MyMovie.MyMovie)
    
    # instantiate controller with model and view
    controller = MovieController.MovieController(db, TextMovieView.TextMovieView())
    
    # display movies
    controller.display()
    
if __name__ == '__main__': 
    main()
