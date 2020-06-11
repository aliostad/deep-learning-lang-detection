package benoit.ascats.typeclasses

import cats.implicits._

case class Person(name:String, age:Int, occupation:String)

object PrintersImplementations {

  implicit val personPrinter:PrintableTypeClass[Person] = new PrintableTypeClass[Person] {
    override def write(p: Person): String = s"Person ${p.name} is ${p.age} and works as a ${p.occupation}"
  }
}

trait PrintableTypeClass[A] {

  def write(a:A): String

}


object PrinterApi {

  def write[A](a:A)(implicit printer:PrintableTypeClass[A]) = printer.write(a)
}

object PrinterSyntax {

  implicit class PrinterOps[A](a:A) {
    def write(implicit printer: PrintableTypeClass[A]) = {
      printer.write(a)
    }
  }
}


