import scala.concurrent.ExecutionContext.Implicits.global
import scala.concurrent.duration.Duration
import scala.concurrent.{ Await, Future }

object GetFutureResult {
  def main(args: Array[String]): Unit = {
    println("Process 1. main process starts")
    var result = 0
    println("Process 1. the curent value of result: "+result)
    val f2: Future[Unit] = Future {
        println("Process 2. asynchronous process starts")
        Thread.sleep(1000)
        result = 1+1
        println("Process 2. asynchronous process ends")
    }
    println("Process 1. doing something else")
    Thread.sleep(100)
    println("Process 1. finishes other stuff, will wait for process 2 to complete if it hasn't already")
    Await.ready(f2, Duration.Inf)
    println("Process 1. the curent value of result: "+result)
  }
}
