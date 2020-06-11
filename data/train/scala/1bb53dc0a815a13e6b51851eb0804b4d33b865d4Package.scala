package ch.inventsoft.scalabase

import scala.util.continuations._
import scala.concurrent.SyncVar
import time._
import executionqueue._
import process.cps._


/**
 * Lightweight processes (aka actors). See Process for detailed documentation.
 */
package object process {
  type process = ProcessCps.process
  type Selector[+A] = process.Messages.MessageSelector[A]

  /**
   * Spawns a new process.
   */
  def spawnProcess(executionQueue: ExecutionQueue)(body: => Any @process): Process = {
    ProcessCps.spawnProcess(executionQueue)(body)
  }

  /** Spawn a child process and return a selector on its result */
  def spawnAndReceive[A](body: => A @process, executionQueue: ExecutionQueue = execute, kind: ChildType = Required): Selector[A] @process = {
    import process.Messages._
    val token = RequestToken.create[A]
    spawnChildProcess(executionQueue)(kind) {
      val result = body
      token.reply(result)
    }
    token.select
  }
  /**
   * Spawns a process and blocks while waiting for its result. Only use outside of processes (i.e. to start up the
   * first process
   */
  def spawnAndBlock[A](body: => A @process, executionQueue: ExecutionQueue = execute): A = {
    val result = new SyncVar[Either[A,Throwable]]
    spawn {
      import process.Messages._
      val token = RequestToken.create[A]
      val child = spawnChildProcess(executionQueue)(Monitored) {
        val result = body
        token.reply(result)
      }
      receive {
        case ProcessExit(`child`) => 
          val r = token.select.receive
          result.set(Left(r))
        case ProcessCrash(`child`, reason) =>
          result.set(Right(new ProcessCrashedException(child, reason)))
        case ProcessKill(`child`, by, reason) =>
          result.set(Right(new ProcessKilledException(child, by, reason)))
      }
    }
    result.get match {
      case Left(result) => result
      case Right(error) => throw error
    }
  }                                                                                                  
  
  /**
   * Spawns a new process with the default priority.
   */
  def spawn(body: => Any @process): Process =
    spawnProcess(execute)(body)
  /**
   * Spawns a new process with background priority.
   */
  def spawnBackground(body: => Any @process): Process = 
    spawnProcess(executeInBackground)(body)
  /**
   * Spawns a new process with high priority.
   */
  def spawnHighPrio(body: => Any @process): Process = 
    spawnProcess(executeHighPrio)(body)
  
  /**
   * Spawns a child process. The process will be linked to the calling process (the parent).
   */
  def spawnChildProcess(executionQueue: ExecutionQueue)(kind: ChildType)(body: => Any @process): Process @process = 
    ProcessCps.spawnChildProcess(executionQueue, kind, body)
    
  /**
   * Spawns a child process with the default priority.
   * The process will be linked to the calling process (the parent).
   */
  def spawnChild(kind: ChildType)(body: => Any @process): Process @process =
    spawnChildProcess(execute)(kind)(body)
  /**
   * Spawns a child process with background priority.
   * The process will be linked to the calling process (the parent).
   */
  def spawnBackgroundChild(kind: ChildType)(body: => Any @process): Process @process =
    spawnChildProcess(executeInBackground)(kind)(body)
  /**
   * Spawns a child process with high priority.
   * The process will be linked to the calling process (the parent).
   */
  def spawnHighPrioChild(kind: ChildType)(body: => Any @process): Process @process =
    spawnChildProcess(executeHighPrio)(kind)(body)

  /**
   * Spawns a (non-child) process add atomically the new process as a watcher for
   * the calling process.
   */
  def spawnWatcherProcess(executionQueue: ExecutionQueue)(body: => Any @process): Process @process = 
    ProcessCps.spawnWatcherProcess(executionQueue)(body)
  /**
   * Spawns a watcher for the caller with the default priority.
   * This equals (but in an atomic fashion):
   * <code>
   *  val p = self
   *  val c = spawn {
   *    watch(p)
   *    body
   *  }
   * </code>
   */
  def spawnWatcher(body: => Any @process): Process @process = 
    spawnWatcherProcess(execute)(body)

  /** Spawns a process watched by the calling process. */
  def spawnWatchedProcess(executionQueue: ExecutionQueue)(body: => Any @process): Process @process =
    ProcessCps.spawnWatchedProcess(executionQueue)(body)
  /**
   * Spawns a process that watches the calling process (with a default priority).
   * This equals (but in an atomic fashion):
   * <code>
   *  val p = spawn {
   *    body
   *  }
   *  watch(p)
   * </code>
   */  
  def spawnWatched(body: => Any @process): Process @process =
    spawnWatchedProcess(execute)(body)

  /**
   * Receives the next matching message for the process. Blocks until a message is
   * received (indefinitly is no matching message is received).
   * @param f message processor
   * @return the value returned by the message processor
   */
  def receive[T](f: PartialFunction[Any,T @process]): T @process =
    ProcessCps.receive(f)
  /**
   * Receives the next matching message for the process. Blocks until a message is
   * received or the timeout is expired. A timeout expiration results in a Timeout
   * message.
   * @param timeout timespan after that the Timeout message is received
   * @param f message processor
   * @return the value returned by the message processor
   */
  def receiveWithin[T](timeout: Duration)(f: PartialFunction[Any,T @process]): T @process =
    ProcessCps.receiveWithin(timeout)(f)
  /**
   * Receives the next matching message with a timeout of 0. Does not block, but instead
   * results in an immediate Timeout if no matching message is waiting.
   * @param f message processor
   * @return the value returned by the message processor
   */
  def receiveNoWait[T](f: PartialFunction[Any,T @process]): T @process = 
    ProcessCps.receiveNoWait(f)
    
  /**
   * Registers this process as a watcher on the <i>toWatch</i> process. The process will
   * receive ProcessEnd messages for the process.
   * @param toWatch
   * @return nothing
   */
  def watch(toWatch: Process): Unit @process = ProcessCps.watch(toWatch)

  /**
   * @return the the current process (external view)
   */
  def self: Process @process = ProcessCps.self

  /**
   * Set a user readable name for this process.
   * This will be used in toString of the process and for logging.
   * Example: Name = "<Process-12>" changes to "<MyListener-12>" after calling processName("MyListener")
   */
  def processName(name: String): Unit @process = processName(Some(name))
  def processName(name: Option[String]): Unit @process = ProcessCps.processName(name)
  
  /**
   * @return a no-op cps
   */
  def noop: Unit @process = ProcessCps.noop
  /**
   * @return the value as a cps
   */
  implicit def valueToCps[A](value: A): A @process = ProcessCps.valueToCps(value) 
  
  
  /**
   * Advanced functions, that should only be used in special cases, mostly inside frameworks.
   */
  object useWithCare {
    /**
     * @return the process executing the calling code. It's better to use 'self', but currentProcess
     * might be easier in some cases.
     */
    def currentProcess: Option[Process] = ProcessCps.useWithCare.currentProcess
  }  

  /**
   * Message signaling an expired timeout.
   * @see process.receiveWithin and process.receiveNoWait
   */
  object Timeout {
    override def toString = "Timeout"
  }
  
  
  
  //CPS Util functions
  
  implicit def cpsIterable[A](ita: Iterable[A]) = CpsUtils.cpsIterable(ita)
  implicit def cpsOption[A](option: Option[A]) = CpsUtils.cpsOption(option)
  implicit def cpsPartialFunction[A,B,X](fun: PartialFunction[A,B @cps[X]]) = CpsUtils.cpsPartialFunction(fun)
}

package process {
  case class ProcessCrashedException(process: Process, reason: Throwable)
       extends RuntimeException(
         "Process "+process+" crashed: "+reason.getClass.getSimpleName+" "+reason.getMessage,
         reason)
    
  case class ProcessKilledException(process: Process, by: Process, reason: Throwable)
       extends RuntimeException(
         "Process "+process+" killed by "+by+": "+reason.getClass.getSimpleName+" "+reason.getMessage,
         reason)
}
