import play.sbt.PlayRunHook
import sbt._
 
import java.net.InetSocketAddress
 
object Grunt {
  def apply(base: File): PlayRunHook = {
 
    object GruntProcess extends PlayRunHook {

      var process: Option[Process] = None

      override def beforeStarted(): Unit = {
        Process("grunt --force", base).run
      }
      override def afterStarted(addr: InetSocketAddress): Unit = {
        process = Some(Process("grunt --force watch", base).run)
      }
      override def afterStopped(): Unit = {
        process.map(p => p.destroy())
        process = None
      }

    }

    GruntProcess
  }
}