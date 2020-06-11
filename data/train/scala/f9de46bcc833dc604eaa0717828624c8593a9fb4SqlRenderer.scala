
package de.tudresden.inf.lat.tabulas.ext.renderer

import java.io.{OutputStreamWriter, Writer}
import java.util.Objects

import de.tudresden.inf.lat.tabulas.datatype._
import de.tudresden.inf.lat.tabulas.parser.ParserConstant
import de.tudresden.inf.lat.tabulas.renderer.{Renderer, UncheckedWriter, UncheckedWriterImpl}
import de.tudresden.inf.lat.tabulas.table.{Table, TableMap}

import scala.collection.mutable

/**
  * Renderer of tables in SQL format.
  */
class SqlRenderer extends Renderer {

  val DefaultSize: Int = 0x800
  val DefaultDatabaseName: String = "tabula"
  val CreateDatabase: String = "create database"
  val Use: String = "use"
  val CreateTable: String = "create table"
  val LeftPar: String = "("
  val RightPar: String = ")"
  val DefaultFieldType: String = "varchar(" + DefaultSize + ")"
  val Comma: String = ","
  val Semicolon: String = ";"
  val Values: String = "values"
  val Null: String = "null"
  val Apostrophe: String = "'"
  val InsertInto: String = "insert into"
  val ApostropheReplacement: String = "%27"
  val Asc: String = "asc"
  val Desc: String = "desc"
  val SelectAllFrom: String = "select * from"
  val OrderBy: String = "order by"

  private var _output: Writer = new OutputStreamWriter(System.out)

  def this(output: Writer) = {
    this()
    this._output = output
  }

  def sanitize(str: String): String = {
    return str.replace(Apostrophe, ApostropheReplacement)
  }

  def writeAsStringIfNotEmpty(output: UncheckedWriter, field: String, value: PrimitiveTypeValue): Boolean = {
    var result: Boolean = false
    if (Objects.nonNull(field) && !field.trim().isEmpty && Objects.nonNull(value)
      && !value.toString.trim().isEmpty) {
      output.write(Apostrophe)
      output.write(sanitize(value.toString))
      output.write(Apostrophe)
      result = true
    } else {
      output.write(Null)
      result = false
    }

    return result
  }

  def writeParameterizedListIfNotEmpty(output: UncheckedWriter, field: String, list: ParameterizedListValue): Boolean = {
    var result: Boolean = false
    if (Objects.nonNull(list) && !list.isEmpty) {
      output.write(Apostrophe)
      list.foreach(value => {
        output.write(sanitize(value.toString))
        output.write(ParserConstant.Space)
      })
      output.write(Apostrophe)
      result = true
    } else {
      output.write(Null)
      result = false
    }

    return result
  }

  def writeLinkIfNotEmpty(output: UncheckedWriter, prefix: String, link: URIValue): Boolean = {
    var result: Boolean = false
    if (Objects.nonNull(link) && !link.isEmpty) {
      output.write(prefix)
      output.write(Apostrophe)
      output.write(sanitize(link.toString))
      output.write(Apostrophe)
      result = true
    } else {
      output.write(Null)
      result = false
    }

    return result
  }

  def render(output: UncheckedWriter, tableName: String, record: Record, fields: mutable.Buffer[String]): Unit = {
    output.write(ParserConstant.NewLine)
    output.write(InsertInto)
    output.write(ParserConstant.Space)
    output.write(tableName)
    output.write(ParserConstant.Space)
    output.write(Values)
    output.write(ParserConstant.Space)
    output.write(LeftPar)
    output.write(ParserConstant.Space)

    var first: Boolean = true
    for (field: String <- fields) {
      if (first) {
        first = false
      } else {
        output.write(Comma)
      }
      output.write(ParserConstant.NewLine)
      val optValue: Option[PrimitiveTypeValue] = record.get(field)
      if (optValue.isDefined) {
        val value: PrimitiveTypeValue = optValue.get
        if (value.isInstanceOf[ParameterizedListValue]) {
          val list: ParameterizedListValue = value.asInstanceOf[ParameterizedListValue]
          writeParameterizedListIfNotEmpty(output, field, list)

        } else if (value.isInstanceOf[URIValue]) {
          val link: URIValue = value.asInstanceOf[URIValue]
          writeLinkIfNotEmpty(output, field, link)

        } else {
          writeAsStringIfNotEmpty(output, field, value)

        }

      } else {
        output.write(Null)
      }
    }
    output.write(ParserConstant.NewLine)
    output.write(RightPar)
    output.write(Semicolon)
  }

  def renderAllRecords(output: UncheckedWriter, tableName: String, table: CompositeTypeValue): Unit = {
    val list: mutable.Buffer[Record] = table.getRecords
    output.write(ParserConstant.NewLine)
    list.foreach(record => {
      render(output, tableName, record, table.getType.getFields)
      output.write(ParserConstant.NewLine)
    })
    output.write(ParserConstant.NewLine)
  }

  def renderTypes(output: UncheckedWriter, tableName: String, table: CompositeTypeValue): Unit = {
    output.write(ParserConstant.NewLine + ParserConstant.NewLine)
    output.write(CreateTable + ParserConstant.Space)
    output.write(tableName + ParserConstant.Space)
    output.write(LeftPar)
    output.write(ParserConstant.NewLine)
    var first: Boolean = true
    for (field: String <- table.getType.getFields) {
      if (first) {
        first = false
      } else {
        output.write(Comma)
        output.write(ParserConstant.NewLine)
      }
      output.write(field)
      output.write(ParserConstant.Space)
      output.write(DefaultFieldType)
    }
    output.write(ParserConstant.NewLine)
    output.write(RightPar)
    output.write(Semicolon)
    output.write(ParserConstant.NewLine)
    output.write(ParserConstant.NewLine)
  }

  def renderOrder(output: UncheckedWriter, tableName: String, table: Table): Unit = {
    output.write(ParserConstant.NewLine)
    output.write(SelectAllFrom)
    output.write(ParserConstant.Space)
    output.write(tableName)
    output.write(ParserConstant.NewLine)
    output.write(OrderBy)
    output.write(ParserConstant.Space)

    var first: Boolean = true
    for (field: String <- table.getSortingOrder) {
      if (first) {
        first = false
      } else {
        output.write(Comma)
        output.write(ParserConstant.Space)
      }
      output.write(field)
      output.write(ParserConstant.Space)
      if (table.getFieldsWithReverseOrder.contains(field)) {
        output.write(Desc)
      } else {
        output.write(Asc)
      }
    }
    output.write(Semicolon)
    output.write(ParserConstant.NewLine)
    output.write(ParserConstant.NewLine)
  }

  def renderPrefix(output: UncheckedWriter): Unit = {
    output.write(ParserConstant.NewLine)
    output.write(CreateDatabase + ParserConstant.Space + DefaultDatabaseName + Semicolon)
    output.write(ParserConstant.NewLine)
    output.write(ParserConstant.NewLine)
    output.write(Use + ParserConstant.Space + DefaultDatabaseName + Semicolon)
    output.write(ParserConstant.NewLine)
    output.write(ParserConstant.NewLine)
  }

  def render(output: UncheckedWriter, tableMap: TableMap): Unit = {
    renderPrefix(output)
    tableMap.getTableIds.foreach(tableName => {
      val table: Table = tableMap.getTable(tableName).get
      renderTypes(output, tableName, table)
      renderAllRecords(output, tableName, table)
      renderOrder(output, tableName, table)
    })
    output.write(ParserConstant.NewLine)
    output.flush()
  }

  override def render(tableMap: TableMap): Unit = {
    render(new UncheckedWriterImpl(this._output), tableMap)
  }

}

