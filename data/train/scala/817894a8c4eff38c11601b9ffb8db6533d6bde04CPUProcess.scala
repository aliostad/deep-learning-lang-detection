package parallelLab2
import java.util.concurrent.Semaphore
import parallelLab2._

class myThread(val threadId:Int, val time: Int, val queue:CPUQueue[myProcess]) extends Runnable {
  var processCounter = 0
  def run() = {
    while (true) {
      writeQueue(generate())
      Thread sleep time
    }
  }
  def writeQueue(p: myProcess): Unit = {
    queue.synchronized {
      queue += p
      println(queue)
    }
  }
  def generate(): myProcess = {
    val p = new myProcess(processCounter, threadId)
    println("New Process : " + p + " created")
    processCounter = processCounter + 1
    p
  }
}
  