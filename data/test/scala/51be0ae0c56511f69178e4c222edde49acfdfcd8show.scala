package chrome

trait Show[T] {
  def show(t: T): String
}

object Show {
  implicit object ShowTab extends Show[Tab] {
    def show(t: Tab): String = t.info.toString
  }
  def apply[T: Show](t: T) = implicitly[Show[T]].show(t)
}

object TerminalDisplay {
  implicit object ShowTab extends Show[Tab] {
    import Term._
    def show(t: Tab): String =
      """[%s]
      |%s: %s
      |%s: %s
      |%s: %s
      |%s: %s
      |%s: %s""".stripMargin.format(
        cyan(t.info.title),
        bold("url"), t.info.url,
        bold("front-end url"), t.info.frontEndUrl,
        bold("favicon"), t.info.faviconUrl,
        bold("thumbnail"), t.info.thumbnail,
        bold("ws debug url"), t.info.wsdebugUrl
      )
  }
}
