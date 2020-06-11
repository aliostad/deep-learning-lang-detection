//Created By Ilan Godik
package nightra.mashovNotificator.xml

import scalaz._
import Scalaz._
import scalaz.Show
import scalaz.std.iterable._
import nightra.mashovNotificator.util.Printer._

object XmlPrinter {

  implicit def showAttribute: Show[Attribute] =
    Show.shows {
      case Attribute(key, "") => ""
      case Attribute(key, value) => s" $key='$value'"
    }

  implicit def showAttributes: Show[Seq[Attribute]] =
    Show.shows(_.foldMap(_.shows))


  def showEmptyXMLTag: Show[XML] =
    Show.shows {
      tag =>
        import tag._
        s"<$label${attributes.show}/>"
    }

  def showNonEmptyXMLTagPretty: Show[XML] =
    Show.shows {
      tag =>
        import tag._
        s"<$label${attributes.show}>$text${showChildrenPretty(children)}</$label>"
    }

  def showChildrenPretty(children: Seq[XML]): String =
    if (children.isEmpty)
      ""
    else {
      for {
        child <- children
        childShow = showXML(pretty = true).shows(child)
        line <- childShow.lines
      } yield tab + line
    }.mkString(line, line, line)


  def showNonEmptyXMLTagCompact: Show[XML] =
    Show.shows {
      tag =>
        import tag._
        s"<$label${attributes.show}>$text${children.foldMap(showXML(pretty = false).shows)}</$label>"
    }

  def showNonEmptyXMLTag(pretty: Boolean): Show[XML] =
    if (pretty) showNonEmptyXMLTagPretty
    else showNonEmptyXMLTagCompact

  def showXML[A <: XML](pretty: Boolean): Show[A] =
    Show.shows {
      xml =>
        if (xml.isEmpty)
          showEmptyXMLTag(xml)
        else
          showNonEmptyXMLTag(pretty)(xml)
    }

  implicit def showXMLPretty[A <: XML]: Show[A] = showXML(pretty = true)

  def showXMLCompact[A <: XML]: Show[A] = showXML(pretty = false)

}
