import _root_.CPUImpl._

object System extends App {
  var globalTime: Int = 0

  private val processes = List(
    Process(10, 5l, 1, List(CPU(10), IO(5), CPU(50))),
    Process(10, 5l, 2, List(IO(5), CPU(20))),
    Process(10, 5l, 3, List(CPU(50))),
    Process(10, 5l, 4, List(CPU(15), IO(15), CPU(15)))
  )

  private val scheduler = Scheduler(new FCFSStrategy)
  processes.foreach(scheduler.addProcess)

  private val nextProcess: Process = scheduler.next
  def require(resource : String, time : Int): Unit ={
    if (resource == "CPU") CPUImpl.require(nextProcess, time)
    else if(resource == "IO") CPUImpl.require(nextProcess, time)
  }
}

object CPUImpl{
  def require(process : Process, time: Int) = {
    wait(time * 250)
  }
}

object IOImpl{
  def require(process : Process, time: Int) = {
    wait(time * 250)
  }
}
