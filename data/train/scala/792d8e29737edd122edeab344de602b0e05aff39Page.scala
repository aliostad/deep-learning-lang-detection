package pageobject

import org.jsoup.nodes.Element
import org.jsoup.Jsoup
import webclient.WebClient

trait LazyPage {

  lazy val page: Element = loadPage(source)

  def loadPage(source: Any) = {
    source match {
      case url: String   => loadPageFromUrl(url)
      case elem: Element => loadPageFromElement(elem)
      case source: Any   => loadPageFromSource(source)
    }
  }

  def loadPageFromUrl(url: String): Element = WebClient.getPage(url)

  def loadPageFromElement(elem: Element): Element = elem

  def loadPageFromSource(source: Any): Element = Jsoup.parse("")

  val source: Any

}

