import collection.immutable.HashMap
import io.{Codec, Source}
import java.io.{InputStreamReader, FileInputStream, FileReader, BufferedReader}

/**
 * Created with IntelliJ IDEA.
 * User: krzysiek
 * Date: 04.06.13
 * Time: 23:37
 * To change this template use File | Settings | File Templates.
 */
object NGramBuilder {

  type NGramMap = collection.mutable.Map[String, Int]

  def key(words: Seq[String]): String = words.mkString("#")

  val reg = """[A-Za-zżźćńółęąśŻŹĆĄŚĘŁÓŃ]+|\.|,""".r


  def buildNGrams(n: Int, old: NGramMap)(words: Iterator[String]): NGramMap = {

    val head = words.take(n).toSeq

    old.put(key(head), 1)

    words.foldLeft(head.toVector) {
      case (buffer, word) =>
        val nb = buffer.drop(1) :+ word
        val k = key(buffer)
        old.put(k, (old.get(k).getOrElse(0) + 1))
        nb
    }
    old
  }


  def createNGrams(path: String, n: Int, old: NGramMap) = NGramBuilder.buildNGrams(n, old) {
    Source.fromFile(path)(Codec("ISO-8859-2")).getLines().map(_.toLowerCase).flatMap(reg.findAllIn)
  }

}
