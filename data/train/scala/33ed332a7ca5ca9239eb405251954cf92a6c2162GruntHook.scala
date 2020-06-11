import java.net.InetSocketAddress

import play.sbt.PlayRunHook
//import play.PlayRunHook
import sbt._

object GruntHook {

  def apply(base: File): PlayRunHook = {

      object GruntProcess extends PlayRunHook {

        var process: Option[Process] = None

        override def beforeStarted(): Unit = {
          Process("grunt react", base).run
          (Process("grunt clean", base) ### Process("grunt copy", base)).run
        }

        override def afterStarted(addr: InetSocketAddress): Unit = {
          process = Some(Process("grunt watch").run)
        }

        override def afterStopped(): Unit = {
          process.map(p => p.destroy())
          process = None
        }
      }
      GruntProcess
  }

}