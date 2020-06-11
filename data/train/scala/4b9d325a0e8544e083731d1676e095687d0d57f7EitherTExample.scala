import scala.concurrent._
import scala.concurrent.duration._
import scala.concurrent.ExecutionContext.Implicits.global
import scalaz.Scalaz._
import scalaz._

object EitherTExample {

  def main(args: Array[String]): Unit = {
    println(Await.result(load(0).run, 1 second))
  }

  case class User(id: Int)
  case class Foo()

  case class UserNotFound(id: Int)
  case class FooNotFound(user: User)

  sealed trait LoadError
  case class LoadErrorUser(e: UserNotFound) extends LoadError
  case class LoadErrorFoo(e: FooNotFound) extends LoadError

  object LoadError {
    def user(e: UserNotFound): LoadError = LoadErrorUser(e)
    def foo(e: FooNotFound): LoadError = LoadErrorFoo(e)
  }

  def loadUser(id: Int): EitherT[Future, UserNotFound, User] = EitherT(Future(id match {
    case 0 => User(0).right
    case i => UserNotFound(i).left
  }))

  def loadFoo(u: User): EitherT[Future, FooNotFound, List[Foo]] = EitherT(Future(u match {
    case User(0) => List(Foo()).right
    case _ => FooNotFound(u).left
  }))

  def load(id: Int): EitherT[Future, LoadError, List[Foo]] =
    for {
      u <- loadUser(id).leftMap(LoadError.user)
      b <- loadFoo(u).leftMap(LoadError.foo)
    } yield b
}
