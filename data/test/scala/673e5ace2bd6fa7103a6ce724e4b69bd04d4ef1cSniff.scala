import scala.xml.{Elem, Null, XML}

object Sniff {
  def main(args: Array[String]) {
    val dirty = XML.load("config.xml")

    println("ELEMENTS")
    dumpElementNames(dirty)

    println()
    println("ATTRIBUTES")
    dumpAttributeNames(dirty)
    dumpAttributeValues(dirty)
  }

  def dumpAttributeNames(dirty: Elem): Unit = {
    dumpCountByValue((dirty \\ "_").flatMap(node =>
      node.attributes match {
        case Null =>
          Seq.empty
        case other =>
          other.map(_.key)
      }
    ))
  }

  def dumpElementNames(dirty: Elem): Unit = {
    dumpCountByValue((dirty \\ "_").map(_.label))
  }

  def dumpAttributeValues(dirty: Elem): Unit = {
    dumpCountByValue((dirty \\ "_").flatMap(node =>
      node.attributes match {
        case Null =>
          Seq.empty
        case other =>
          other.map(_.value.text)
      }
    ))
  }

  def dumpCountByValue(values: Seq[String]): Unit = {
    values.groupBy(s => s)
      .mapValues(_.size)
      .toSeq.sortBy(_._2).reverse
      .foreach(printKV)
  }

  def printKV(it: (String, Int)) = {
    val (key, value) = it
    println(s"$key: $value")
  }

//  def allAttributeValues(xml: Elem): Set[String] = {
//
//  }
}
