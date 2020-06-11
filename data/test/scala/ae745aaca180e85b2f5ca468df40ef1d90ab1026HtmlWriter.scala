package anchorman.html

import anchorman.core._
import java.io._
import unindent._
import scala.concurrent.{ExecutionContext => EC, _}

object HtmlWriter extends DocumentWriter {
  def write(doc: Document, stream: OutputStream)(implicit ec: EC): Future[Unit] =
    Future.successful {
      val writer = new OutputStreamWriter(stream)
      try {
        writer.write(writeDocument(doc))
      } finally {
        writer.close()
      }
    }

  def writeDocument(doc: Document): String = {
    val Document(block, _, _, _, _, _) = doc

    i"""
    <!DOCTYPE html>
    <html>
    <head>
    <style>
      table {
        width: 100%;
        margin: .5em 0;
      }

      th, td {
        border: 1px solid black;
        padding: .5em 1ex;
      }
    </style>
    </head>
    <body>
    ${writeBlock(block)}
    </body>
    </html>
    """
  }

  def writeBlock(block: Block): String =
    block match {
      case EmptyBlock                       => ""
      case BlockSeq(blocks)                 => blocks.map(writeBlock).mkString("\n")
      case Para(span, ParaType.Title, _)    => i"""<h1>${writeSpan(span)}</h1>"""
      case Para(span, ParaType.Heading1, _) => i"""<h2>${writeSpan(span)}</h1>"""
      case Para(span, ParaType.Heading2, _) => i"""<h3>${writeSpan(span)}</h2>"""
      case Para(span, ParaType.Heading3, _) => i"""<h4>${writeSpan(span)}</h3>"""
      case Para(span, ParaType.Default, _)  => i"""<p>${writeSpan(span)}</p>"""
      case OrderedList(items)               => i"""<ol>${items.map(writeListItem).mkString}</ol>"""
      case UnorderedList(items)             => i"""<ul>${items.map(writeListItem).mkString}</ul>"""
      case Columns(columns)                 => writeBlock(Table(Seq(TableRow(columns.map(TableCell(_))))))
      case table @ Table(rows, _, _) =>
        i"""
        <table style="width: 100%; border: 1px solid black">
        ${writeColumnWidths(table)}
        ${rows.map(writeTableRow).mkString("\n")}
        </table>
        """
    }

  def writeListItem(item: ListItem): String =
    i"<li>${writeBlock(item.block)}</li>"

  def writeColumnWidths(table: Table): String =
    table.columns map {
      case TableColumn.Auto          => i"""<col width="*"></col>"""
      case TableColumn.Fixed(length) => i"""<col style="width: ${length}pt"></col>"""
    } mkString "\n"

  def writeTableRow(row: TableRow): String =
    i"""<tr>${row.cells.map(writeTableCell).mkString}</tr>"""

  def writeTableCell(cell: TableCell): String =
    i"""<td>${writeBlock(cell.block)}</td>"""

  def writeSpan(span: Span): String =
    span match {
      case EmptySpan      => ""
      case Text(text, _)  => text
      case Image(url)     => i"""<img src="${url}">"""
      case SpanSeq(spans) => spans.map(writeSpan).mkString
    }

}