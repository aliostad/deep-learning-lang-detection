package rml

import java.io.Writer
import java.io.StringWriter
import scala.xml.Node

case class RstFormatter(rst: Writer, css: StringBuffer) {

  def writeTitle(title: String, depth: Int, tocDepth: Int) = {
    
    val titleStyles = """=-`:.'"~^_*+#""".split("") // Array("", "=", "-", "`", ":", ".", "'", "\"", "~", "^", "_", "*", "+", "#")
    
    val titleStyle = titleStyles(depth)
    
    if(tocDepth > 0){
      
      rst.write(".. page:: tocPage\n\n")
      rst.write(s".. contents:: $title\n\n")
      rst.write(".. page:: twoColumn ::\n\n")
      
    } else {
      
      rst.write(title)
      rst.write("\n")
      rst.write(titleStyle * title.length)
      rst.write("\n\n")
    }
  }
  
  def writeBreak(breakType: String) = {
    
    rst.write(".. page::\n\n")
  }
  
  def writeSpace(height: Int) = {
    
    rst.write(s".. space:: $height\n\n")
  }
  
  def writeText(text: String) = {
    
    rst.write(text)
    rst.write("\n\n")
  }
  
  def writeTable(cols: List[(String, String)], data: List[Map[String, String]], width: String) = {
    
    val widths = for((key, title) <- cols) yield {
      key -> (title.size :: data.map(_(key).size)).max
    }

    val widthMap = widths.toMap
    
    def mkLine(sep: String) = widths.map(x => sep * (x._2 + 2)).mkString("+", "+", "+")
    
    def mkContent(row: Map[String, String]) = (for((key, width) <- widths) yield {
      s" %-${width}s ".format(row(key))
    }).mkString("|", "|", "|")
    
    val horizontal = mkLine("-")
    val headerSep = mkLine("=")

    val headers = for((key, title) <- cols) yield s" %-${widthMap(key)}s ".format(title)
      
    rst.write(s".. widths:: $width")
    rst.write("\n")
    rst.write("\n")
    rst.write(horizontal)
    rst.write("\n")
    rst.write(headers.mkString("|", "|", "|"))
    rst.write("\n")
    rst.write(headerSep)
    rst.write("\n")
    
    for(row <- data) {
      rst.write(mkContent(row))
      rst.write("\n")
      rst.write(horizontal)
      rst.write("\n")
    }

    rst.write("\n")
    
  }
  
  def writeList(col: String, data: List[Map[String, String]], enumOption: Option[Seq[Node]]) = {
    
    val enum = for(enum <- enumOption) yield enum.text.toInt
    
    for((row, i) <- data.zipWithIndex) {
      
      val nummer = enum.map(_ + i).map(_ + ".")
      
      rst.write(nummer.getOrElse("-"))
      rst.write(" ")
      rst.write(row(col).trim)
      rst.write("\n")
    }

    rst.write("\n")
  }
  
  def writeImg(url: String, title: Option[String], width: Option[String], height: Option[String], pdfscale: Option[String]) = {
    
    rst.write(s".. figure:: $url\n")
    rst.write(s"   :figwidth: 100%\n")
    rst.write(s"   :align: left\n")
    
    for(w <- width){
      rst.write(s"   :width: 100%\n")
      css.append(s"img[src='$url']{width:$w;}\n")
    }
    
    for(scale <- pdfscale){
      rst.write(s"   :scale: $scale\n")
    }
    
    for(t <- title)
      rst.write(s"\n   $t\n")
    
    rst.write("\n")
  }

}
