package com.oradian.autofuture

import org.specs2.Specification

class AutoFutureSpec extends Specification {
  def is = s2"""
    Chaining of AutoFutures
      process two             $processTwo

    Noops during processing
      process before noop     $processBeforeNoop
      process after noop      $processAfterNoop
      process two noops       $processTwoNoops

    Errors during processing
      process before error    $processBeforeError
      process after error     $processAfterError
      process two errors      $processTwoErrors
  """

  private[this] case class PrefixFuture(snippet: String) extends AutoFuture {
    def apply(source: String) = AutoFuture.Result.Success(snippet + source)
  }

  private[this] case class SuffixFuture(snippet: String) extends AutoFuture {
    def apply(source: String) = AutoFuture.Result.Success(source + snippet)
  }

  private[this] case class ErrorFuture(message: String) extends AutoFuture {
    def apply(source: String) = AutoFuture.Result.Error(message)
  }

  private[this] object NoopFuture extends AutoFuture {
    def apply(source: String) = AutoFuture.Result.Noop
  }

  def processTwo = AutoFuture.process(
    source = "abc"
  , tasks = List(PrefixFuture("123"), SuffixFuture("789"))
  , last = AutoFuture.Result.Noop
  ) ==== AutoFuture.Result.Success("123abc789")

  // Noops during processing

  def processBeforeNoop = AutoFuture.process(
    source = "abc"
  , tasks = List(PrefixFuture("123"), NoopFuture)
  , last = AutoFuture.Result.Noop
  ) ==== AutoFuture.Result.Success("123abc")

  def processAfterNoop = AutoFuture.process(
    source = "abc"
  , tasks = List(NoopFuture, SuffixFuture("789"))
  , last = AutoFuture.Result.Noop
  ) ==== AutoFuture.Result.Success("abc789")

  def processTwoNoops = AutoFuture.process(
    source = "abc"
  , tasks = List(NoopFuture, NoopFuture)
  , last = AutoFuture.Result.Noop
  ) ==== AutoFuture.Result.Noop

  // Errors during processing

  def processBeforeError = AutoFuture.process(
    source = "abc"
  , tasks = List(PrefixFuture("123"), ErrorFuture("E2"))
  , last = AutoFuture.Result.Noop
  ) ==== AutoFuture.Result.Error("E2")

  def processAfterError = AutoFuture.process(
    source = "abc"
  , tasks = List(ErrorFuture("E1"), SuffixFuture("789"))
  , last = AutoFuture.Result.Noop
  ) ==== AutoFuture.Result.Error("E1")

  def processTwoErrors = AutoFuture.process(
    source = "abc"
  , tasks = List(ErrorFuture("E1"), ErrorFuture("E2"))
  , last = AutoFuture.Result.Noop
  ) ==== AutoFuture.Result.Error("E1")
}
