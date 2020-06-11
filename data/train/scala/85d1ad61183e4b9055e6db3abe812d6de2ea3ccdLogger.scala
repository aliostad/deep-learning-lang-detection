package com.mycompany.scalcium.utils

object Logger {
  def getLogger(name: String): Logger = {
    if ("none".equalsIgnoreCase(name)) new NullLogger()
    else new DebugLogger()
  }  
}

trait Logger {
  def log(message: String): Unit
  def dump(): String
}

class NullLogger extends Logger {
  def log(message: String): Unit = {}
  def dump(): String = { "" }
}

class DebugLogger extends Logger {
  
  val buf = new StringBuilder()
  
  def log(message: String): Unit = {
    buf.append("\n").append(message)
  }
  
  def dump(): String = {
    buf.toString()
  }
}
