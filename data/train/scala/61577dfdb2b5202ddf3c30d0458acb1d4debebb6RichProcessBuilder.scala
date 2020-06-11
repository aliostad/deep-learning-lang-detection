package org.codeswarm.processenrich

import scala.sys.process.ProcessBuilder

/** Adds additional functionality to `ProcessBuilder`.
  *
  * @param pb The underlying `ProcessBuilder`.
  */
class RichProcessBuilder(pb: ProcessBuilder) {

  /** Starts the process represented by this builder, blocks until it exits, and
    * returns the output from stdout and stderr as `String`s.
    */
  def stringOutput: ProcessOutput[String] = {
    val log = StringBuilderProcessLogger()
    pb ! log
    log.stringOutput
  }

}

object RichProcessBuilder {

  /** Implicitly convert a ProcessBuilder to a RichProcessBuilder. */
  implicit def apply[A <% ProcessBuilder](p: A): RichProcessBuilder = new RichProcessBuilder(p)

}