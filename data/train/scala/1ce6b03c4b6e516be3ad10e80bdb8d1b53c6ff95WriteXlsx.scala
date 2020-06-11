package sheetkram.io.ooxml

import java.io.File
import java.io.FileOutputStream

import org.apache.poi.xssf.usermodel.{ XSSFWorkbook => XlsxWorkbook }

import sheetkram.io.WriteWorkbook
import sheetkram.model.Workbook

object WriteXlsx extends WriteWorkbook with WriteOoxml {

  def toFile( workbook : Workbook, file : File ) : Unit = {
    val xlsxWorkbook : XlsxWorkbook = new XlsxWorkbook()
    doWrite( workbook, xlsxWorkbook )
    val out = new FileOutputStream( file )
    try {
      xlsxWorkbook.write( out )
    } finally {
      out.close()
    }
  }

}
