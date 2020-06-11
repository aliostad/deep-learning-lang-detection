package org.ssm.parser

import org.ssm.parser.model.SSMMessage

import scala.util.Try

sealed trait Process[I, O, S] {
  def apply(stream: Stream[I]): Try[O] = ???
}

object Process {

  case object End extends Throwable

  case object Kill extends Throwable

  case class Start[I, O, S](init: () => (S, Process[I, O, S]))
    extends Process[I, O, S]

  case class Await[I, O, S](recv: (Option[I], Process[I, O, S]) => Process[I, O, S])
    extends Process[I, O, S]

  case class Parse[K, I, O, S](kind: K,
                               run: (I, S, K) => (S, Process[I, O, S]))
    extends Process[I, O, S]

  case class Emit[I, S, O](f: S => (O, Process[I, O, S]))
    extends Process[I, O, S]

  case class Halt[I, O, S](i: Option[I],
                           e: Throwable)
    extends Process[I, O, S]

  def start[I, O, S](init: => (S, Process[I, O, S])): Process[I, O, S] =
    Start(() => init)

  def await[I, O, S](recv: (Option[I], Process[I, O, S]) => Process[I, O, S]): Process[I, O, S] =
    Await(recv)

  def parse[K, I, O, S](kind: K)(implicit run: (I, S, K) => (S, Process[I, O, S])): Process[I, O, S] =
    Parse(kind, run)

  def emit[I, O, S](f: S => (O, Process[I, O, S])): Process[I, O, S] =
    Emit(f)

  def end[I, O, S]: Process[I, O, S] =
    Halt(None, End)

  def kill[I, O, S](i: I): Process[I, O, S] =
    Halt(Some(i), Kill)
}

sealed trait SSMParseKind

case object ToAddress extends SSMParseKind

case object FromAddress extends SSMParseKind

case object Identifier extends SSMParseKind

case object TimeMode extends SSMParseKind

case object Reference extends SSMParseKind

case object Action extends SSMParseKind

case object FlightInformation extends SSMParseKind

case object PeriodInformation extends SSMParseKind

case object OtherInformation extends SSMParseKind

case object SubMessage extends SSMParseKind

object SSMProcess {
  type Input = (Int, String)
  type Result = (SSMMessage, SSMProcess)
  type SSMProcess = Process[Input, SSMMessage, SSMMessage]

  def parseSSMMessage(str: String): SSMMessage =
    ???

  def toJsonString(ssmMessage: SSMMessage): String = ???
}
