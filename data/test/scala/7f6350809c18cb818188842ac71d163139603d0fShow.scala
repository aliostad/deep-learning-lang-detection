package unicorn
import simulacrum._
/*
  Simple Show typles
  To use: import unicorn.Show._
          import unicorn.Show.ops._

           Show[Int].show(1)
           1.show             //enabled via simulacrm

 */
@typeclass trait Show[A]{
  def show(a: A): String
}

object Show{
  implicit def intShow = new Show[Int]{
    def show(i: Int) = s"$i"
  }

  def optionShow[A: Show] = new Show[Option[A]]{
    implicit def show(oa: Option[A]): String = oa match {
      case Some(a) => implicitly[Show[A]].show(a)
      case None => "None"
    }
  }
}

