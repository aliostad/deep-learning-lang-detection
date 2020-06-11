//     Project: sdocx
//      Module:
// Description:

// Copyright (c) 2015 Johannes Kastner <jokade@karchedon.de>
//                      Distributed under the MIT license.
package biz.enef.sdocx.word.table

import java.io.Writer

import biz.enef.sdocx.opc.XMLSerializable
import biz.enef.sdocx.word.WordBodyContent

case class Table(props: Iterable[TableProperty], cols: Seq[TableColumn], rows: TableRow*) extends WordBodyContent {
  final def write(w: Writer): Unit = {
    w.write("""<w:tbl><w:tblPr>""")
    props.foreach(_.write(w))
    w.write("""</w:tblPr><w:tblGrid>""")
    cols.foreach(_.write(w))
    w.write("""</w:tblGrid>""")
    rows.foreach( _.write(w) )
    w.write("</w:tbl>")
  }
}

trait TableXMLContent extends XMLSerializable
  with TableProperty
  with TableColumn
  with TableRow
  with TableRowProperty
  with TableCell
  with TableCellProperty
