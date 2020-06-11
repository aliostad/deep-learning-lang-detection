package com.springer.samatra.routing

import java.lang.management.ManagementFactory
import java.util.concurrent.TimeoutException
import java.util.concurrent.atomic.AtomicReference
import javax.servlet.http.{HttpServletRequest, HttpServletResponse}
import javax.servlet.{AsyncContext, AsyncEvent, AsyncListener}

import com.springer.samatra.routing.Routings.HttpResp

import scala.concurrent.{ExecutionContext, Future}
import scala.language.implicitConversions
import scala.util.Try

object FutureResponses {

  val defaultTimeout = 15000

  object Implicits {
    implicit def fromFuture[T](fut: Future[T])(implicit rest: T => HttpResp, executor: ExecutionContext = ExecutionContext.global): HttpResp = FutureResponses.fromFuture(fut, logThreadDumpOnTimeout = false)
  }

  def fromFuture[T](fut: Future[T], logThreadDumpOnTimeout: Boolean)(implicit rest: T => HttpResp, executor: ExecutionContext = ExecutionContext.global): HttpResp =
    FutureHttpResp(fut, defaultTimeout, rest, executor, logThreadDumpOnTimeout)

  def fromFutureWithTimeout[T](timeout: Long, fut: Future[T], logThreadDumpOnTimeout: Boolean = false)(implicit rest: T => HttpResp, executor: ExecutionContext = ExecutionContext.global): HttpResp =
    FutureHttpResp(fut, timeout, rest, executor, logThreadDumpOnTimeout)

  sealed trait State
  case object Running extends State
  case object Rendering extends State
  case object Timedout extends State

  case class FutureHttpResp[T](fut: Future[T], timeout: Long, rest: T => HttpResp, executionContext: ExecutionContext, logThreadDumpOnTimeout: Boolean) extends HttpResp {
    override def process(req: HttpServletRequest, resp: HttpServletResponse): Unit = {
      val state = new AtomicReference[State](Running)

      val async: AsyncContext = req.startAsync(req, resp)

      async.setTimeout(timeout)
      async.addListener(new TimingOutListener(state, timeout, logThreadDumpOnTimeout)) //Does not stop the future running. You must do this

      fut.onComplete { t =>
        if (state.getAndSet(Rendering) == Running) {
          val asyncResponse: HttpServletResponse = async.getResponse.asInstanceOf[HttpServletResponse]
          val asyncRequest: HttpServletRequest = async.getRequest.asInstanceOf[HttpServletRequest]
          try {
            rest(t.get).process(asyncRequest, asyncResponse)
          } catch {
            case t: Throwable =>
              if (!asyncResponse.isCommitted) {
                req.setAttribute("javax.servlet.error.exception", t)
                asyncResponse.sendError(500)
              }
          } finally {
            Try { asyncResponse.getOutputStream.close() }
            Try { async.complete() }
          }
        }
      }(executionContext)
    }
  }

  class TimingOutListener(state: AtomicReference[State], timeout: Long, logThreadDumpOnTimeout: Boolean) extends AsyncListener {
    override def onError(event: AsyncEvent): Unit = ()
    override def onComplete(event: AsyncEvent): Unit = ()
    override def onStartAsync(event: AsyncEvent): Unit = ()
    override def onTimeout(event: AsyncEvent): Unit =
      if (state.getAndSet(Timedout) == Running) {
        val response: HttpServletResponse = event.getAsyncContext.getResponse.asInstanceOf[HttpServletResponse]
        try {
          if (!response.isCommitted) {
            event.getSuppliedRequest.setAttribute("javax.servlet.error.exception",
              new TimeoutException(s"Request exceeded timeout of $timeout\n${if (logThreadDumpOnTimeout) ThreadDumps.generateThreadDump() else ""}"))
            response.sendError(500)
          }
        } finally {
          Try { response.getOutputStream.close() }
          Try { event.getAsyncContext.complete()}
        }
      }
  }

  object ThreadDumps {
    def generateThreadDump(): String = {
      val dump = new StringBuilder()
      val threadMXBean = ManagementFactory.getThreadMXBean
      threadMXBean.getThreadInfo(threadMXBean.getAllThreadIds, 100).foreach { threadInfo =>
        dump.append('"')
        dump.append(threadInfo.getThreadName)
        dump.append("\" ")
        val state = threadInfo.getThreadState
        dump.append("\n   java.lang.Thread.State: ")
        dump.append(state)
        threadInfo.getStackTrace.foreach { stackTraceElement =>
          dump.append("\n        at ")
          dump.append(stackTraceElement)
        }
        dump.append("\n\n")

        dump.toString()
      }
      dump.result()
    }
  }
}
