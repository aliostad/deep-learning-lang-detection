package etlmail.engine.css

import org.apache.commons.lang.StringUtils.strip
import org.jsoup.nodes.Document
import scala.collection.JavaConversions._

case class SimpleCssRule(selector: Selector, properties: String) extends Ordered[SimpleCssRule] {
  override def compare(o: SimpleCssRule): Int = selector.specificity.compare(o.selector.specificity)

  def prependProperties(doc: Document) {
    for (selElem <- doc.select(selector.toString)) {
      val oldProperties = selElem.attr("style")
      selElem.attr("style", concatenateProperties(oldProperties, properties))
    }
  }

  private def concatenateProperties(oldProp: String, newProp: String): String =
    strip(newProp) + strip(oldProp)
}
