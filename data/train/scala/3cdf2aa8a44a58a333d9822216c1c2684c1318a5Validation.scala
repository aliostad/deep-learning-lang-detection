/**
 * Copyright (C) 2013 Typesafe <http://typesafe.com/>
 */
package activator

import language._
import java.io.File
/**
 * This class represents some kind of result of an (sequence of) operation(s) that may or may not have failed.
 * You can later extract the result, or group together errors.
 *
 * This also allows running "validations" against a last run state to aggregate the errors.
 */
sealed abstract class ProcessResult[+T] {

  /**
   * Takes a series of validation functions and
   * runs them against the current value (if defined).  If any fail, their error messages
   * are added to the set of failures returned.
   */
  def validate(validations: (T => Option[ProcessError])*): ProcessResult[T] =
    this match {
      case ProcessSuccess(value) =>
        validations flatMap (validate => validate(value).toSeq) match {
          case Seq() => this // WE PASS
          case errors => ProcessFailure(errors)
        }
      case x => x
    }

  /** Groups two Processes resutls together, aggregating failrues, if any are discovered. */
  def zip[U](other: ProcessResult[U]): ProcessResult[(T, U)] =
    (this, other) match {
      case (ProcessSuccess(lhs), ProcessSuccess(rhs)) => ProcessSuccess(lhs -> rhs)
      case (ProcessFailure(errors), ProcessFailure(errors2)) => ProcessFailure(errors ++ errors2)
      case (_, err: ProcessFailure) => err
      case (err: ProcessFailure, _) => err
    }

  def map[U](f: T => U): ProcessResult[U] =
    this match {
      // TODO -> Catch errors?
      case ProcessSuccess(value) => ProcessSuccess(f(value))
      case err: ProcessFailure => err
    }

  def flatMap[U](f: T => ProcessResult[U]): ProcessResult[U] =
    this match {
      case err: ProcessFailure => err
      case ProcessSuccess(value) => f(value)
    }

  def foreach[U](f: T => U): Unit =
    this match {
      case ProcessSuccess(value) => f(value)
      case _ => ()
    }

  /** Allows you to handle success/failure states and return a new value. */
  final def fold[U](success: T => U, failure: Seq[ProcessError] => U): U =
    this match {
      case ProcessSuccess(value) => success(value)
      case ProcessFailure(errors) => failure(errors)
    }

  def isSuccess: Boolean =
    this match {
      case _: ProcessSuccess[T] => true
      case _ => false
    }
  def isFailure: Boolean = !isSuccess

  def ensureErrorContainsFilename(file: File): ProcessResult[T] = this match {
    case f: ProcessFailure => if (f.failures.map(_.msg.contains(file.getName)).reduce(_ || _)) {
      f
    } else {
      ProcessFailure(f.failures.map(err => ProcessError(s"${file.getName}: ${err.msg}", err.cause)))
    }
    case other => other
  }
}

object ProcessResult {

  // BIG UGLY CONVERSIONS
  implicit class opt2Process[U](val t: Option[U]) extends AnyVal {
    def validated(msg: String): ProcessResult[U] =
      t match {
        case Some(result) => ProcessSuccess(result)
        case None => ProcessFailure(msg)
      }
  }
  implicit final def try2Process[U](t: util.Try[U]): ProcessResult[U] =
    t match {
      case util.Success(result) => ProcessSuccess(result)
      case util.Failure(err) => ProcessFailure(err)
    }
  implicit final def eitherString2Process[U](value: util.Either[String, U]): ProcessResult[U] =
    value match {
      case Left(errMsg) => ProcessFailure(errMsg)
      case Right(result) => ProcessSuccess(result)
    }
  implicit final def eitherThrowable2Process[U](value: util.Either[Throwable, U]): ProcessResult[U] =
    value match {
      case Left(errMsg) => ProcessFailure(errMsg)
      case Right(result) => ProcessSuccess(result)
    }
  // TODO - necessary or just UGLY?

  import concurrent._
  implicit class uglyFutureChainingJunk[T](val value: Future[ProcessResult[T]]) extends AnyVal {
    // Since we're not using Scalaz and crazy moandT junk, we just hack the hell out of our normal stack of monads.
    def flatMapNested[U](f: T => Future[ProcessResult[U]])(implicit ctx: ExecutionContext): Future[ProcessResult[U]] = {
      val result = Promise[ProcessResult[U]]()
      value map {
        case ProcessSuccess(value) =>
          f(value) onComplete { result complete _ }
        case failure: ProcessFailure => result success failure // The paradox is killing me.
      }
      result.future
    }
  }
  implicit class uglyChainingJunk2[T](val value: ProcessResult[T]) extends AnyVal {
    def flatMapNested[U](f: T => Future[ProcessResult[U]])(implicit ctx: ExecutionContext): Future[ProcessResult[U]] = {
      val result = Promise[ProcessResult[U]]()
      value match {
        case ProcessSuccess(v) =>
          f(v) onComplete { result complete _ }
        case failure: ProcessFailure => result success failure // The paradox is killing me. AGAIN!
      }
      result.future
    }
  }
}
/**
 * Captures an error.  May be just a message, or a message combined with a throwable "cause".
 *
 * The assumption is that the message is some high-level use-case specific problem, while
 * the throwable contains nitty gritty details that may or may not be useful.
 */
case class ProcessError(msg: String, cause: Option[Throwable])
object ProcessError {
  def apply(msg: String) = new ProcessError(msg, None)
  def apply(err: Throwable) = new ProcessError(Option(err.getMessage).getOrElse(err.getClass.getName), Some(err))
  def apply(msg: String, cause: Throwable) = new ProcessError(msg + Option(cause.getMessage).map(": " + _).getOrElse(""),
    Some(cause))

  // TODO - auto lift throwables a good idea?
  implicit final def throwable2Error(t: Throwable): ProcessError = apply(t)
  implicit final def string2Error(t: String): ProcessError = apply(t)
}

/**
 * This class represents a successful validation
 */
final case class ProcessSuccess[T](value: T) extends ProcessResult[T]
final case class ProcessFailure(failures: Seq[ProcessError]) extends ProcessResult[Nothing]
object ProcessFailure {
  def apply(failure: ProcessError): ProcessFailure = new ProcessFailure(Seq(failure))
}

/**
 * This object provides a way to wrap an expression so that the result
 * is placed into a  ProcessResult[T].  If any non-fatal errors happen during the
 * execution, they are captured in the failure state.
 *
 * You can also use the "withMsg" function to ensure a useful error message on failure.
 *
 */
object Validating {
  def apply[T](process: => T): ProcessResult[T] = util.Try(process)
  def withMsg[T](msg: String)(process: => T): ProcessResult[T] =
    util.Try(process) match {
      case util.Success(result) => ProcessSuccess(result)
      case util.Failure(err) => ProcessFailure(ProcessError(msg, err))
    }
}

/**
 * This class makes it easier to run validations against ProcessResults, so that
 * we can do things like form validation in a simple syntax.
 */
object Validation {
  def make[T](msg: T => String)(check: T => Boolean): T => Option[ProcessError] = { value =>
    if (check(value)) None
    else Some(msg(value))
  }
  def apply[T](msg: String)(check: T => Boolean): T => Option[ProcessError] = { value =>
    if (check(value)) None
    else Some(msg)
  }

  def fileExists = make[java.io.File](file => s"${file} does not exist")(_.exists)
  def isDirectory = make[java.io.File](file => s"${file} is not a directory")(_.isDirectory)
  def nonEmptyString(name: String) = apply[String](s"$name must be non-empty")(!_.isEmpty)
  def nonEmptyCollection(name: String) = apply[Traversable[_]](s"$name must be non-empty")(!_.isEmpty)
  def looksLikeAnSbtProject: File => Option[ProcessError] =
    make[java.io.File](file => s"Directory does not contain an sbt build: ${file}")(Sbt.looksLikeAProject(_))
}
