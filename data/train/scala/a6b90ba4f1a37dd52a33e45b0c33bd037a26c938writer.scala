package com.wellhead.lasso

import java.io._
import java.text.DecimalFormat
import scala.collection.jcl.Conversions._
import java.util.{List,ArrayList}

class LasFileWriter extends LasWriter {
  val form = new DecimalFormat
  form.setMaximumFractionDigits(20)
  form.setMaximumIntegerDigits(20)
  form.setGroupingUsed(false)
  
  override def writeLasFile(lf: LasFile, path:String) { 
    if(path == "stdout"){
      writeLasFile(lf, new BufferedWriter(new OutputStreamWriter(System.out)))
    }
    else {
      writeLasFile(lf, new File(path))
    }
  }
  
  override def writeCurve(curve:Curve, path:String) {
    throw new UnsupportedOperationException("oops, haven't implemented this yet")
  }

  override def canWrite(protocol:String) = protocol == "file"

  private def writeLasFile(lf: LasFile, file:File) { 
    val writer = new BufferedWriter(new FileWriter(file))
    writeLasFile(lf, writer)
  }

  private def writeLasFile(lf:LasFile, writer:BufferedWriter) {
    val write = (s:String) => writer.write(s)
    try {
      writeHeaders(lf, writer)
      writeCurves(lf, writer)
    } finally {
      writer.close()
    }
  }    

  private def writeHeaders(lf: LasFile, writer:BufferedWriter) {
    val headers = lf.getHeaders
    for(h <- headers) {
      writeHeader(h, writer)
    }
  }

  private def writeHeader(h:Header, writer:BufferedWriter) {
    writer.write(h.getPrefix); writer.newLine
    writeDescriptors(h.getDescriptors, writer)
  }

  private def writeDescriptors(descriptors:List[Descriptor], writer: BufferedWriter){
    for(d <- descriptors){
      writeDescriptor(d, writer)
    }
  }

  private def writeDescriptor(descriptor:Descriptor, writer: BufferedWriter) {
    val write = (s:String) => writer.write(s)
    write(descriptor.getMnemonic)
    write(" .")
    write(descriptor.getUnit)
    write(" ")
    write(descriptor.getData)
    write(" : ")
    write(descriptor.getDescription)
    writer.newLine
  }

  private def writeCurves(lf: LasFile, writer: BufferedWriter) {
    writer.write("~A")
    writer.newLine
    val curves = {
      val list = new ArrayList[Curve]
      list.add(lf.getIndex)
      lf.getCurves.foreach(c => list.add(c))
      list
    }      
    val columns = curves.size
    val rows = curves.first.getLasData.size
    for(r <- 0 until rows){
      for(c <- curves){
	val data = c.getLasData
	writer.write(form.format(data.get(r)))
	writer.write(" ")
      }
      writer.newLine
    }
  }			     
    
}
