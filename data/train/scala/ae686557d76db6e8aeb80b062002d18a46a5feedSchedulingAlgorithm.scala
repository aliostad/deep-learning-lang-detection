import scala.collection.immutable.Queue

/**
  * Created by nico on 02/05/16.
  */
trait SchedulingAlgorithm {

  def addProcess(process: Process)
  def addProcesses(processes: List[Process])
  def nextProcess: Run
  def nonEmpty: Boolean
  def processes: List[Process]

}

case class Run(process: Process, time: Int)

case class RoundRobinScheduling(quantum: Int) extends SchedulingAlgorithm {

  private var processQueue = Queue[Process]()

  override def addProcess(process: Process) = processQueue = processQueue enqueue process
  override def addProcesses(processes: List[Process]) = processQueue = processQueue enqueue processes

  override def nextProcess: Run = processQueue dequeue match {
    case (process, queue) =>
      processQueue = queue
      val time = if (quantum <= process.remaining) quantum else process.remaining
      Run(process, time)
  }

  override def nonEmpty: Boolean = processQueue.nonEmpty

  override def processes: List[Process] = processQueue.toList
}

case class PriorityScheduling(quantum: Int) extends SchedulingAlgorithm {

  private var processList = List[Process]()

  override def addProcess(process: Process) = processList = process :: processList
  override def addProcesses(processes: List[Process]) = processList = processList ++ processes

  override def nextProcess: Run = {
    val head::tail = processList.sortBy(-_.priority)
    val process = head
    processList = tail
    val time = if (quantum <= process.remaining) quantum else process.remaining
    Run(process, time)
  }

  override def nonEmpty: Boolean = processList.nonEmpty

  override def processes: List[Process] = processList
}

case object FirstComeFirstServeScheduling extends SchedulingAlgorithm {

  private var processQueue = Queue[Process]()

  override def addProcess(process: Process) = processQueue = processQueue enqueue process
  override def addProcesses(processes: List[Process]) = processQueue = processQueue enqueue processes

  override def nextProcess: Run = processQueue dequeue match {
    case (process, queue) =>
      processQueue = queue
      val time = process.remaining
      Run(process, time)
  }

  override def nonEmpty: Boolean = processQueue.nonEmpty

  override def processes: List[Process] = processQueue.toList
}

case object ShortestJobFirstScheduling extends SchedulingAlgorithm {

  private var processList = List[Process]()

  override def addProcess(process: Process) = processList = process :: processList
  override def addProcesses(processes: List[Process]) = processList = processList ++ processes

  override def nextProcess: Run = {
    val head::tail = processList.sortBy(_.cpuTotal)
    val process = head
    processList = tail
    val time = process.remaining
    Run(process, time)
  }

  override def nonEmpty: Boolean = processList.nonEmpty

  override def processes: List[Process] = processList
}
