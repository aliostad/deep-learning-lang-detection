package com.wellhead.lasso
import java.io._
import java.text.DecimalFormat
import scala.collection.jcl.Conversions._
import java.util.{List,ArrayList}

class ClojureWriter extends LasWriter {

  override def writeLasFile(lf: LasFile, path:String) { 
    val writer = new BufferedWriter(if(path == "stdout") new OutputStreamWriter(System.out)
				    else new FileWriter(path))
    try {
      writeLasFile(lf, writer)
    } finally {
      writer.close()
    }
  }

  override def writeCurve(curve:Curve, path:String) { 
    val writer = new BufferedWriter(if(path == "stdout") new OutputStreamWriter(System.out) 
				    else new FileWriter(path))
    try {
      writeCurve(curve, writer)
    } finally {
      writer.close()
    }
  }

  def writeLasFileToString(lf:LasFile):String = {
    val swriter = new StringWriter
    val writer = new BufferedWriter(swriter)
    writeLasFile(lf, writer)
    writer.close()
    swriter.toString
  }

  def writeCurveToString(curve:Curve):String = {
    val swriter = new StringWriter
    val writer = new BufferedWriter(swriter)
    writeCurve(curve, writer)
    writer.close()
    swriter.toString
  }
  
  override def canWrite(protocol:String) = protocol == "clojure"

  private def writeLasFile(lf: LasFile, file:File) { 
    val writer = new BufferedWriter(new FileWriter(file))
    writeLasFile(lf, writer)
  }

  private def writeLasFile(lf:LasFile, writer:BufferedWriter) {
    val write = (s:String) => writer.write(s)
    try {
      write("{")
      write(":name ")
      write(quote(lf.getName))
      write(", ")

      write(":headers ")
      writeHeaders(lf, writer)      
      write(", ")

      write(":curves ")
      writeCurves(lf, writer)
      write("}")
    } finally {
      writer.close()
    }
  }    

  private def writeHeaders(lf: LasFile, writer:BufferedWriter) {
    val headers = lf.getHeaders
    writer.write("[")
    for(h <- headers) {
      writeHeader(h, writer)
      writer.newLine
    }
    writer.write("]")
    writer.newLine
  }

  private def writeHeader(h:Header, writer:BufferedWriter) {
    val write = (s:String) => writer.write(s)
    write("{")
    write(":type ")
    write(quote(h.getType))
    
    write(", ")
    
    write(":prefix ")
    write(quote(h.getPrefix))
    
    writer.newLine

    write(":descriptors ")
    writeDescriptors(h.getDescriptors, writer)
    write("}")
  }

  private def writeDescriptors(descriptors:List[Descriptor], writer: BufferedWriter){
    val write = (s:String) => writer.write(s)
    write("[")
    for(d <- descriptors){
      writeDescriptor(d, writer)
      writer.newLine
    }
    write("]")
  }

  private def writeDescriptor(descriptor:Descriptor, writer: BufferedWriter) {
    val write = (s:String) => writer.write(s)
    write("{")
    write(":mnemonic ")
    write(quote(descriptor.getMnemonic))
    
    write(", ")

    write(":unit ")
    write(quote(descriptor.getUnit.toString))

    write(", ")

    write(":data ")
    write(quote(descriptor.getData.toString))

    write(", ")

    write(":description ")
    write(quote(descriptor.getDescription))
    write("}")
  }

  private def writeIndex(lf: LasFile, writer: BufferedWriter) {
    val write = (s:String) => writer.write(s)
    write(":index ")
    write(quote(lf.getIndex.getMnemonic))
    writer.newLine
  }


  private def writeCurves(lf: LasFile, writer: BufferedWriter) {
    val write = (s:String) => writer.write(s)
    write("[")
    writeCurve(lf.getIndex, writer)
    writer.newLine
    for(curve <- lf.getCurves){
      writeCurve(curve, writer)
      writer.newLine
    }
    write("]")
  }			     

  private def writeCurve(curve:Curve, writer: BufferedWriter) {
    val write = (s:String) => writer.write(s)
    write("{")
    write(":descriptor ")
    writeDescriptor(curve.getDescriptor, writer)
    writer.newLine
    
    write(":data ")

    write("[")
    for(d <- curve.getLasData){
      if(d.isNaN){
	write("java.lang.Double/NaN")
      }
      else {
	write(d.toString)
      }
      write(" ")
    }
    write("]")
    write("}")
  }
  
  private def quote(s:String) = {
    "\"" + escape(s) + "\""
  }
  private def escape(s:String) = {
    s.replaceAll("\"", "\\\\\"")
  }
}

