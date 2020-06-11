package sbtdumpsettings

object DumpSettingsRenderer {
  //type Factory = (Seq[DumpSettingsOption], String, String) => DumpSettingsRenderer
  type Factory = () => DumpSettingsRenderer
}

trait DumpSettingsRenderer {

  def extension: String
  def renderKeys(results: Seq[DumpSettingsResult]): Seq[String]

}

case class JsonRenderer() extends DumpSettingsRenderer {
  override def extension = "json"

  override def renderKeys(results: Seq[DumpSettingsResult]): Seq[String] = {
    List(results.map(result => s"""\"${result.identifier}\":\"${result.value}\"""").mkString("{\n", ",\n", "}"))
  }
}

case class BashRenderer() extends DumpSettingsRenderer with DumpSettingsUtils {
  override def extension = "sh"

  override def renderKeys(results: Seq[DumpSettingsResult]): Seq[String] = {
    results.flatMap(line)
  }

  private def line(result: DumpSettingsResult): Seq[String] = {
    result.value match {
      case mp: Map[_, _] => List(mp.toList.map(x => s"[${x._1}]=${x._2}").mkString(s"declare -A ${result.identifier}=(", " ", ")"))
      case seq: Seq[_] => List(seq.map(quote).mkString(s"declare -a ${result.identifier}=(", " ", ")"))
      case _ => List(s"${result.identifier}=${quote(result.value)}")
    }

  }
}

trait DumpSettingsUtils {

  def quote(v: Any): String = v match {
    case x @ (_: Int | _: Double | _: Boolean | _: Symbol) => x.toString
    case x: Long => x.toString + "L"
    case node: scala.xml.NodeSeq if node.toString().trim.nonEmpty => node.toString()
    case (k, _v) => "(%s -> %s)" format (quote(k), quote(_v))
    case mp: Map[_, _] => mp.toList.map(quote(_)).mkString("[", ", ", "]")
    case seq: Seq[_] => seq.map(quote).mkString("[", ", ", "]")
    case op: Option[_] => op map { x => quote(x) } getOrElse { "" }
    case url: java.net.URL => quote(url.toString)
    case file: java.io.File => quote(file.toString)
    case s => "\"%s\"" format encodeStringLiteral(s.toString)
  }

  def encodeStringLiteral(str: String): String =
    str.replace("\\", "\\\\").replace("\n", "\\n").replace("\b", "\\b").replace("\r", "\\r").
      replace("\t", "\\t").replace("\'", "\\'").replace("\f", "\\f").replace("\"", "\\\"")
}
