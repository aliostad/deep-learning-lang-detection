package midterm

object midterm_8 extends App {
  lections.spam.main(null)

  import lections.spam._

  val oldMovie = List(
    "top gun"
    , "shy people"
    , "top hat"
  )
  val newMovie = List(
    "top gear"
    , "gun shy"
  )
  val allMovies = oldMovie ++ newMovie
  val k = 1
  "ls(old)" =: `ls(_)`(allMovies.size, oldMovie.size, k)
  "ls(new)" =: `ls(_)`(allMovies.size, newMovie.size, k)
  "ls(top|old)" =: `ls(m|_)`("top" :: Nil)(oldMovie, allMovies)(k)
  "ls(top|new)" =: `ls(m|_)`("top" :: Nil)(newMovie, allMovies)(k)

  "ls(old|top)" =: "ls(top|old)".bd * "ls(old)" / ("ls(top|old)".bd * "ls(old)" + "ls(top|new)".bd * "ls(new)")
  "ls(new|top)" =: "ls(top|new)".bd * "ls(new)" / ("ls(top|new)".bd * "ls(new)" + "ls(top|old)".bd * "ls(old)")

}