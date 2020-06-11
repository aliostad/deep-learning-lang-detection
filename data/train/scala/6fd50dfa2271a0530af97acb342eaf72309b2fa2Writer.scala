package lemon.messages.io

import java.util
import lemon.messages.EnumValue

trait Writer {

  def begin(attributes:util.Map[String,Any])

  def writeSupper():Writer

  def writeMessage(name:String,id:Int,attributes:util.Map[String,Any]):Writer

  def writeVar(name:String,id:Int,length:Int,signed:Boolean,value:Long,attributes:util.Map[String,Any])

  def writeFixed(name:String,id:Int,length:Int,value:Long,attributes:util.Map[String,Any])

  def writeString(name:String,id:Int,value:String,attributes:util.Map[String,Any])

  def writeFloat(name:String,id:Int,value:Float,attributes:util.Map[String,Any])

  def writeDouble(name:String,id:Int,value:Double,attributes:util.Map[String,Any])

  def writeBoolean(name:String,id:Int,value:Boolean,attributes:util.Map[String,Any])

  def writeEnum(name:String,id:Int,length:Int,value:EnumValue,attributes:util.Map[String,Any])

  def writeArray(name:String,id:Int,length:Int,attributes:util.Map[String,Any]):SeqWriter

  def writeList(name:String,id:Int,attributes:util.Map[String,Any]):SeqWriter

  def writeSet(name:String,id:Int,attributes:util.Map[String,Any]):SeqWriter

  def writeMap(name:String,id:Int,attributes:util.Map[String,Any]):SeqWriter

  def end()
}

trait SeqWriter{
  def writeNext()
  def writeMessage():Writer
  def writeVar(length:Int,signed:Boolean,value:Long)
  def writeFixed(length:Int,signed:Boolean,value:Long)
  def writeString(value:String)
  def writeBoolean(value:Boolean)
  def writeArray(length:Int):SeqWriter
  def writeList():SeqWriter
  def writeSet():SeqWriter
  def writeMap():SeqWriter
  def writeFloat(value:Float)
  def writeDouble(value:Double)
  def writeEnum(length:Int,value:EnumValue)
}
