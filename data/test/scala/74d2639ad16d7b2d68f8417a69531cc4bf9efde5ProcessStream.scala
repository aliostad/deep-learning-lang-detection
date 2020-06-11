package org.gerweck.scala.util

import java.io._

sealed abstract class ProcessStream {
  type Stream <: Closeable
  /** The stream number, as defined by POSIX. */
  val number: Int
  def of(p: Process): Stream
}

object ProcessStream {
  def fromNumber(n: Int) = n match {
    case 0 => StdInProcessStream
    case 1 => StdOutProcessStream
    case 2 => StdErrProcessStream
    case n => throw new IllegalArgumentException(s"Unknown stream number: $n")
  }
}

case object StdInProcessStream extends ProcessStream {
  type Stream = OutputStream
  final val number = 0
  override def of(p: Process): OutputStream = p.getOutputStream
}

case object StdOutProcessStream extends ProcessStream {
  type Stream = InputStream
  final val number = 1
  override def of(p: Process): InputStream = p.getInputStream
}

case object StdErrProcessStream extends ProcessStream {
  type Stream = InputStream
  final val number = 2
  override def of(p: Process): InputStream = p.getErrorStream
}
