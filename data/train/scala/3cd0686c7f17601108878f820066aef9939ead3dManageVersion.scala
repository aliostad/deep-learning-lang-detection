import scala.annotation.tailrec

class ManageVersion

object ManageVersion {

  def stringToTuple(x: String) = x.split(Array('.', '-')).partition(_.startsWith("RC"))

  /**
   *
   * Compare the main partition.
   *
   */
  @tailrec def compareMain(x: Array[String], y: Array[String]): Int = {
    x.head.toInt.compareTo(y.head.toInt) match {
      case 0 =>
        if (x.tail.isEmpty && x.tail.isEmpty) 0
        else compareMain(x.tail, y.tail)
      case x: Int => x
    }
  }

  /**
   *
   * Compare RC partition.
   *
   */
  def compareRC(x: Array[String], y: Array[String]): Int = {
    if (x.lastOption == None) 1
    else if (y.lastOption == None) -1
    else x.head.last.toInt.compareTo(y.head.last.toInt)
  }

  /**
   *
   * Override Ordering.
   *
   */
  implicit def ordering[A <: String] = new Ordering[A] {
    override def compare(x: A, y: A): Int = {
      val tupleX = stringToTuple(x)
      val tupleY = stringToTuple(y)
      compareMain(tupleX._2, tupleY._2) match {
        case 0 => compareRC(tupleX._1, tupleY._1)
        case x: Int => x
      }
    }
  }

  def latest(versions: Seq[String]): String = {
    versions.max
  }
}
