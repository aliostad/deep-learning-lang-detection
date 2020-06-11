//Created By Ilan Godik
package nightra.mashovNotificator.util

import scalaz.{Cord, Show}
import scala.language.implicitConversions

trait Printer {
  def line = "\r\n"
  def tab = "\t"
  def nested = line + tab

  implicit def liftToShow[A](f: A => String): Show[A] = Show.shows(f)
  implicit def showToString[A](show: Show[A]): A => String = show.shows

  def mkString[A](zero:String)(start:String,sep:String,end:String)(show:Show[A])(seq:Seq[A]): String =
    if(seq.isEmpty) zero
    else (start +: separated(sep, show, seq.toList) :+ end).toString()

  private def separated[A](sep:String,show:Show[A],l:List[A],acc:Cord = Cord()): Cord = l match{
    case List(elem) => acc :+ show.shows(elem)
    case head :: tail => separated(sep,show,tail,acc :+ (head + sep))
  }
  
}

object Printer extends Printer
