package com.babel17.naive

import java.io.File
import com.babel17.syntaxtree.Location


class WriteOutput {

  def writeLineCommentary(s : String) {
    writeLine(s)
  }

  def writeLineSuccess(s : String) {
    writeLine(s)
  }

  def writeLineError(s : String)  {
    writeLine(s)
  }

  def writeLocMsg(prefix : String, loc : Location, message : String) {
    val p = if (prefix == null) "" else prefix+" "
    writeLine(p+"(at "+loc+"): "+message)
  }

  def writeFailedAssertion(loc : Location, message : String) {
    writeLocMsg("failed assertion", loc, message);
    //writeLine("failed assertion (at "+loc+"): "+message);
  }

  def writeProfile(loc : Location, milliseconds : Long, message : String) {
    writeLocMsg("profile", loc, milliseconds+"ms, result = "+message);
  }

  def writeLine(s : String) {
    println(s)
  }

  def pleaseCancel() : Boolean = {
    false;
  }

}