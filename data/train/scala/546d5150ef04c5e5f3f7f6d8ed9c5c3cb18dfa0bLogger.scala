package org.peach

object Logger {
  val ERROR_LEVEL = 0
  val WARN_LEVEL = 10

  require { ERROR_LEVEL < WARN_LEVEL}
}

class Logger(val level: Int = Logger.WARN_LEVEL) {

  import Logger._

  def log(message: => String, level: Int): Unit = {
    if (level <= this.level)
      println("log: " + message)
  }
  def error(message: => String) { log(message, ERROR_LEVEL)}
  def warn(message: => String) { log(message, WARN_LEVEL)}

  def warnByValue(message: String) { warn(message) }

}

trait SampleData {
  val map = Map(
    'first -> "Yellow",
    'second -> "Green",
    'third -> "Red"
  )

  def mapDump: String = {
    println("!!!!!dumping the map!!!!!")
    map.mkString("\n")
  }
}

object BaseSample extends App with SampleData {


  val atError = new Logger(Logger.ERROR_LEVEL)
  val atWarn = new Logger(Logger.WARN_LEVEL)

  println("expects just ciao")
  println("--------------")
  atError.error("ciao")
  atError.warn("hi")
  println("--------------\n")

  println("expects ciao and hi")
  println("--------------")
  atWarn.error("ciao")
  atWarn.warn("hi")
  println("--------------\n")

}


object DumpTheMapSample extends App with SampleData {

  val logger = new Logger(Logger.ERROR_LEVEL)

  println("expects a call to dump the map, it is fine")
  println("--------------")
  logger.error(mapDump)
  println("--------------\n")

}

object DoNotDumpTheMapSample extends App with SampleData {

  val logger = new Logger(Logger.ERROR_LEVEL)

  println("expects NO call to dump the map!")
  println("--------------")
  logger.error("ciao")
  logger.warn(mapDump)
  println("--------------\n")

}

object ButDumpTheMapWhenIsCallByValueSample extends App with SampleData {

  val logger = new Logger(Logger.ERROR_LEVEL)

  println("expects a call to dump the map!")
  println("--------------")
  logger.error("ciao")
  logger.warnByValue(mapDump)
  println("--------------\n")

}

object TogetherSample extends App with SampleData {

  val logger = new Logger(Logger.ERROR_LEVEL)

  println("expects only a call to dump the map!")
  println("--------------")
  logger.error("ciao")
  logger.warn(mapDump)
  logger.warnByValue(mapDump)
  println("--------------\n")

}


