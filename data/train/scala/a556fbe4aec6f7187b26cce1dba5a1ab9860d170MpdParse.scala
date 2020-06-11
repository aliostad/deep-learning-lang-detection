package mpd
package util

object MpdParse {
  implicit  class BooleanMPD(val b: Boolean) extends AnyVal {
    def toMpd = if (b) "1" else "0"
  }

  type ValuePair = (String, Seq[String])

  val songr = """([-\w]*): (.*)""".r

  def valuePairs(v: Traversable[String]): Seq[ValuePair] = {
    val matches = songr.findAllMatchIn(v.mkString("\n"))

    matches.foldLeft(Seq.empty[ValuePair]) { (b, a) =>
      val key = a.group(1).toLowerCase
      val old = for {
        h <- b.lastOption
        if h._1 == key
      } yield h._2

      (if (old.isDefined) b.init else b) :+ 
	(key -> (old.getOrElse(Seq.empty) :+ a.group(2)))
    }
  }

  def mapValues(v: Traversable[String]): Song = valuePairs(v).toMap
}
