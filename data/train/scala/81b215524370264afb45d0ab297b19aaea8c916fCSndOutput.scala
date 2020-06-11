package org.scherzoteller.csndGen.generators.out

import java.io.OutputStream
import org.scherzoteller.csndGen.musicbeans.scoretokens.CSndNote
import org.scherzoteller.csndGen.musicbeans.scoretokens.CSndScoreToken
import org.omg.CORBA.portable.InputStream
import java.io.FileInputStream
import org.apache.commons.io.IOUtils
import java.io.File

class CSndOutput(output: OutputStream) {
	val END_OF_LINE = "\r\n";
  val END_OF_INSTRUCTION = ";"+END_OF_LINE;
  def write(note: CSndScoreToken) = {
    // FIXME Findbugs would say that this is default encoding dependent...
    output.write(note.getValueAsString().getBytes());
  }


  def writeLn(note: CSndScoreToken) = {
    write(note);
    endOfInstruction();
  }
  
  private def endOfInstruction() = {
	  output.write(END_OF_INSTRUCTION.getBytes());
  }
  
  private def newLine() = {
	  output.write(END_OF_LINE.getBytes());
  }
  
  private def writeTag(tag: String) = {
    output.write('<');
    output.write(tag.getBytes());
    output.write('>');
  }
  
  private def writeEndTag(tag: String) = {
	  output.write('<');
	  output.write('/');
	  output.write(tag.getBytes());
	  output.write('>');
  }
  
  def encapsulate(tag: String )(doInside: => Unit): Unit = {
		  writeTag(tag)
		  newLine()
		  doInside
		  newLine()
		  writeEndTag(tag)
		  newLine()
  }
  
  def writeFile(file: File) = {
    IOUtils.copy(new FileInputStream(file), output)
  }
}

