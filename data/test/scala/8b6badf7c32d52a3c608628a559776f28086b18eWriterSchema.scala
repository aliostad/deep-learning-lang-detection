package com.tam.cobol_interpreter.writer.schema

import com.tam.cobol_interpreter.context.{ContextTool, DataContext, WriteContext}
import com.tam.cobol_interpreter.tools.ArrayTool
import com.tam.cobol_interpreter.writer.schema.expressions._

/**
 * Created by tamu on 1/5/15.
 */
class WriterSchema(expressionList: Array[WriterColumnExpression]) {
  def getColumns:Array[String] = this.expressionList.map(_.getColumnName)

  def updateWriteContext(dataContext:DataContext, writeContext: WriteContext): Unit = {
    writeContext.isWritable = true
    WriterSchema.recUpdateWriteContext(dataContext, writeContext, this.expressionList)
  }
}

object WriterSchema {
  def recUpdateWriteContext(dataContext: DataContext, writeContext: WriteContext, expressionList: Array[WriterColumnExpression]): WriteContext = {
    if (expressionList.length <= 0)
      writeContext
    else
      expressionList.head match {
        case col:BasicColumn =>
          writeContext.updateColumnData(col.columnName, dataContext.getData(col.columnName))
          recUpdateWriteContext(dataContext, writeContext, expressionList.tail)
        case col:PersistentColumn =>
          writeContext.updateIfNewColumnData(col.columnName, dataContext.getData(col.columnName))
          recUpdateWriteContext(dataContext, writeContext, expressionList.tail)
        case col:NonEmptyColumn =>
          val colData = dataContext.getData(col.columnName)
          writeContext.isWritable = writeContext.isWritable && !ArrayTool.deepEquals(colData, ContextTool.defaultData())
          writeContext.updateColumnData(col.columnName, colData)
          recUpdateWriteContext(dataContext, writeContext, expressionList.tail)
      }
  }
}
