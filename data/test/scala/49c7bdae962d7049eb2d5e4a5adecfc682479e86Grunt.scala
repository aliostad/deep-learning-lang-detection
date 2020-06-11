import sbt._
import java.net._
import java.io.File
import play.PlayRunHook

object Grunt {
 
  def run(base: File) {
    Process("grunt", base).run
  }


  def apply(base: File): PlayRunHook = {

    object GruntProcess extends PlayRunHook {

      var process: Option[Process] = None

      override def afterStarted(addr: InetSocketAddress): Unit = {
        process = Some(Process("grunt watch", base).run)
      }

      override def afterStopped(): Unit = {
        process.map(p => p.destroy())
        process = None
      }
    }

    GruntProcess
  }
}
