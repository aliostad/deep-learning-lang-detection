package repatch.github.request

import java.util.Calendar

trait Show[A] {
  def shows(a: A): String
}

object Show {
  def showA[A]: Show[A] = new Show[A] {
    def shows(a: A): String = a.toString 
  }
  implicit val stringShow  = showA[String]
  implicit val intShow     = showA[Int]
  implicit val bigIntShow  = showA[BigInt]
  implicit val booleanShow = showA[Boolean]
  implicit val doubleShow  = showA[Double]
  implicit val calendarShow: Show[Calendar] = new Show[Calendar] {
    def shows(a: Calendar): String = javax.xml.bind.DatatypeConverter.printDateTime(a)
  }
  implicit def seqShow[A: Show]: Show[Seq[A]] = new Show[Seq[A]] {
    def shows(as: Seq[A]): String = {
      val f = implicitly[Show[A]]
      (as map f.shows).mkString(",")
    }
  }
}
