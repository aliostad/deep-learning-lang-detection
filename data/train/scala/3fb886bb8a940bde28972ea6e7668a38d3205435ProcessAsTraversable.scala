package com.valdis.adamsons.utils

import scala.sys.process.{ProcessBuilder, ProcessLogger}

/**
 * A Scala collection with all the standard out (stdout) lines from the given process.
 * Important: The values may change because the process runs 
 * on each major operation(like map, foreach, foldLeft etc.) and the new values are used.
 * Old values are not saved in memory.
 * @param errorLogger function, that is run for every standard error (stderr) line.
 */
case class ProcessAsTraversable(processBuilder: ProcessBuilder, errorLogger: String => Unit) extends Traversable[String]{
	def foreach[U](f: String => U): Unit = {
	  val processLogger = ProcessLogger(line => f(line), line => errorLogger(line))
	  val process = processBuilder.run(processLogger)
	  process.exitValue()
	}
}