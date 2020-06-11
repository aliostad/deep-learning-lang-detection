/**
 * Experimental ManageVersion.
 *
 *  limitation： The version number is less than 2.
 *
 */
class ManageVersion2

object ManageVersion2 {

  def stringToTuple(x: String) = x.split(Array('.', '-')).partition(_.startsWith("RC"))

  implicit def ordering[A <: String] = new Ordering[A] {
    override def compare(x: A, y: A): Int = {
      val arrMX = stringToTuple(x)._2
      val arrMY = stringToTuple(y)._2
      val arrRCX = stringToTuple(x)._1
      val arrRCY = stringToTuple(y)._1

      var weightX, weightY = 0.0

      (2 to 0 by -1) foreach { n =>
        weightX += math.pow(100, n) * arrMX(2 - n).toInt
        weightY += math.pow(100, n) * arrMY(2 - n).toInt
      }

      weightX.compareTo(weightY) match {
        case 0 =>
          if (arrRCX.headOption == None) 1
          else if (arrRCY.headOption == None) -1
          else arrRCX.head.last.getNumericValue.compareTo(arrRCY.head.last.getNumericValue)
        case x: Int => x
      }

    }
  }

  def latest(versions: Seq[String]): String = {
    versions.max
  }
}
