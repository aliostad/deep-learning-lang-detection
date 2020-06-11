package org.scalawag.sdom.output

import org.scalawag.sdom._
import java.io.{PrintWriter, Writer}
import scala.xml.Utility.escape

object PrettyPrintOutputter extends Outputter {
  import Outputter._

  override def output(node:Node,writer:Writer) = {
    val pw = new PrintWriter(writer)

    def helper(node:Node,indent:String = ""):Unit = node match {
      case d:Document =>
        // TODO: xml version, etc.
        d.children.foreach(helper(_,""))

      case e:Element =>
        val qn = qname(e)

        pw.write(indent)
        pw.write('<')
        pw.write(qn)

        val attributeLikes:Iterable[Node] = ( e.attributes ++ e.namespaces )

        attributeLikes.headOption.foreach(helper(_," "))

        val attrIndent = indent + " " * ( 1 + qn.length + 1)

        ( if ( attributeLikes.isEmpty ) Iterator.empty else attributeLikes.tail ) foreach { a =>
          pw.println
          pw.write(attrIndent)
          helper(a,"")
        }

        // Remove whitespace-only children
        val children = e.children.filter( c => ! c.isInstanceOf[TextLike] || ! c.asInstanceOf[TextLike].text.trim.isEmpty )

        if ( children.isEmpty ) {
          pw.write("/>")
        } else {
          pw.write('>')
          if ( children.forall(_.isInstanceOf[TextLike]) ) {
            children.foreach(helper(_))
          } else {
            children.foreach { c =>
              pw.println()
              helper(c, indent + "  ")
            }
            pw.println()
            pw.print(indent)
          }
          pw.write("</")
          pw.write(qn)
          pw.write('>')
        }

      case a:Attribute =>
        pw.write(indent)
        pw.write(qname(a))
        pw.write("=\"")
        pw.write(escape(a.value))
        pw.write('"')

      case n:Namespace =>
        pw.write(indent)
        pw.write("xmlns")
        if ( ! n.prefix.isEmpty ) {
          pw.write(':')
          pw.write(n.prefix)
        }
        pw.write("=\"")
        pw.write(escape(n.uri))
        pw.write('"')

      case t:Text =>
        pw.write(indent)
        pw.write(escape(t.text.trim))

      case c:CData =>
        pw.write(indent)
        pw.write("<![CDATA[")
        pw.write(c.text) // TODO: escape bad characters?
        pw.write("]]>")

      case c:Comment =>
        pw.write(indent)
        pw.write("<!--")
        pw.write(c.text) // TODO: escape bad characters?
        pw.write("-->")

      case p:ProcessingInstruction =>
        pw.write(indent)
        pw.write("<?")
        pw.write(p.target) // TODO: escape
        pw.write(' ')
        pw.write(p.data) // TODO: escape
        pw.write("?>")
    }

    helper(node)
  }
}

/* sdom -- Copyright 2014 Justin Patterson -- All Rights Reserved */
