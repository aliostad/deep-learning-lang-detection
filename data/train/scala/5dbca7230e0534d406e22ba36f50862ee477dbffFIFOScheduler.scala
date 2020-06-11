package edu.deanza.cis31.scheduler

import edu.deanza.cis31.kernel.Process
import scala.collection.mutable


class FIFOScheduler extends Scheduler {

  val queue = mutable.Queue[Process]()
  var timeQuantum: Int = 0

  override def exec(process: Process) = {
    queue += process
  }

  override def currentProcess() = queue.head

  override def tick() = {
    // preemption if needed
    if (timeQuantum == 0) {
      val current = queue.dequeue()
      current.state = Process.State.Ready
      queue.enqueue(current)
      timeQuantum = osParams.initialQuantum
      queue.head.state = Process.State.Running
    }

    // tick
    timeQuantum -= 1
  }

  override def getAllProcesses = queue.toList

  override def terminateCurrentProcess() = {
    val p = queue.dequeue()
    p.state = Process.State.Terminated
  }

}
