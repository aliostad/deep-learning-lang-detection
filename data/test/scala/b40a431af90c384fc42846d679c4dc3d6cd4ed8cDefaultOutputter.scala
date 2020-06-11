package org.scalawag.sdom.output

import org.scalawag.sdom._
import java.io.Writer
import scala.xml.Utility.escape

object DefaultOutputter extends Outputter {
  import Outputter._

  override def output(node:Node,writer:Writer) = node match {
    case d:Document =>
      // TODO: xml version, etc.
      d.children.foreach(output(_,writer))

    case e:Element =>
      val qn = qname(e)

      writer.write('<')
      writer.write(qn)

      e.attributes foreach { a =>
        writer.write(' ')
        output(a,writer)
      }

      e.namespaces foreach { n =>
        writer.write(' ')
        output(n,writer)
      }

      if ( e.children.isEmpty ) {
        writer.write("/>")
      } else {
        writer.write('>')
        e.children.foreach(output(_,writer))
        writer.write("</")
        writer.write(qn)
        writer.write('>')
      }

    case a:Attribute =>
      writer.write(qname(a))
      writer.write("=\"")
      writer.write(escape(a.value))
      writer.write('"')

    case n:Namespace =>
      writer.write("xmlns")
      if ( ! n.prefix.isEmpty ) {
        writer.write(':')
        writer.write(n.prefix)
      }
      writer.write("=\"")
      writer.write(escape(n.uri))
      writer.write('"')

    case t:Text =>
      writer.write(escape(t.text))

    case c:CData =>
      writer.write("<![CDATA[")
      writer.write(c.text) // TODO: escape bad characters?
      writer.write("]]>")

    case c:Comment =>
      writer.write("<!--")
      writer.write(c.text) // TODO: escape bad characters?
      writer.write("-->")

    case p:ProcessingInstruction =>
      writer.write("<?")
      writer.write(p.target) // TODO: escape
      writer.write(' ')
      writer.write(p.data) // TODO: escape
      writer.write("?>")
  }
}

/* sdom -- Copyright 2014 Justin Patterson -- All Rights Reserved */
