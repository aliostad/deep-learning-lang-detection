package net.randata

object Data {
  private def load(name: String): IndexedSeq[String] = {
    val is = getClass.getResourceAsStream(name + ".txt")
    val br = new java.io.BufferedReader(new java.io.InputStreamReader(is, "UTF-8"))
    val buffer = new scala.collection.immutable.VectorBuilder[String]

    def read(): Unit = {
      Option(br.readLine).map(_.trim) match {
        case Some(line) =>
          buffer += line
          read()
        case _ =>
      }
    }

    read()
    br.close()
    buffer.result
  }

  val AccountDescriptions = load("account-descriptions")
  val Animals             = load("animals")
  val Cities              = load("cities")
  val Colors              = load("colors")
  val CompanyNames        = load("company-names")
  val CompanyPrefixes     = load("company-prefixes")
  val CompanySuffixes     = load("company-suffixes")
  val Countries           = load("countries")
  val Currencies          = load("currencies")
  val Descriptions        = load("descriptions")
  val EmailDomains        = load("email-domains")
  val NamesFemale         = load("names-female")
  val NamesLast           = load("names-last")
  val NamesMale           = load("names-male")
  val Other               = load("other")
  val StreetNames         = load("street-names")
  val StreetSuffxes       = load("street-suffixes")
}
