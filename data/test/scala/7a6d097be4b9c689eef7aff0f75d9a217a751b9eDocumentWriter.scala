package at.hazm.webserver.templates.xml

import java.io.Writer
import java.nio.charset.Charset

import org.w3c.dom._


object DocumentWriter {

  /**
    * 内容が空であったとしても終タグを記述する要素名 (すべて小文字)。
    */
  val KeepEndElementIfEmpty:Set[String] = Set("div", "script", "iframe", "pre", "canvas", "div", "span", "textarea",
    "a", "b", "p", "i")

  /**
    * 内容のテキストをエスケープしない。
    */
  val ContentWithoutEscape:Set[String] = Set("script", "style")

  def write(out:Writer, charset:Charset, doc:Document):Unit = {
    out.write("<!DOCTYPE html SYSTEM \"about:legacy-compat\">\n")
    // out.write("<?xml version=\"1.0\" encoding=\"" + charset.name() + "\"?>\n")
    write(out, doc.getDocumentElement, noescape = false)
    out.flush()
  }

  private[this] def write(out:Writer, node:Node, noescape:Boolean):Unit = node match {
    case e:Element =>
      out.write("<")
      out.write(e.getTagName)
      val as = e.getAttributes
      for(i <- 0 until as.getLength) {
        val a = as.item(i).asInstanceOf[Attr]
        out.write(' ')
        out.write(a.getName)
        out.write("=\"")
        out.write(escape(a.getValue))
        out.write('\"')
      }
      val cs = e.getChildNodes.toList.filter {
        case t:Text => t.getData.nonEmpty
        case _ => true
      }
      if(cs.nonEmpty || KeepEndElementIfEmpty.contains(e.getTagName.toLowerCase)) {
        out.write('>')
        cs.foreach { c => write(out, c, noescape || ContentWithoutEscape.contains(e.getTagName.toLowerCase)) }
        out.write("</")
        out.write(e.getTagName)
        out.write('>')
      } else {
        out.write("/>")
      }
    case t:CDATASection =>
      out.write("<![CDATA[")
      out.write(t.getData)
      out.write("]]>")
    case t:Text =>
      out.write(if(noescape) t.getData else escape(t.getData))
    case pi:ProcessingInstruction =>
      out.write("<?")
      out.write(pi.getTarget)
      if(pi.getData.nonEmpty) {
        out.write(' ')
        out.write(pi.getData)
      }
      out.write("?>")
    case c:Comment =>
      out.write("<!--")
      out.write(c.getData)
      out.write("-->")
  }

  private[this] def escape(text:String):String = {
    val buffer = new StringBuilder()
    text.foreach {
      case '<' => buffer.append("&lt;")
      case '>' => buffer.append("&gt;")
      case '&' => buffer.append("&amp;")
      case '\"' => buffer.append("&quot;")
      case '\'' => buffer.append("&apos;")
      case ch =>
        if(Character.isDefined(ch)) {
          buffer.append(ch)
        } else {
          buffer.append(f"&#u${ch.toInt}%04X;")
        }
    }
    buffer.toString()
  }

}
