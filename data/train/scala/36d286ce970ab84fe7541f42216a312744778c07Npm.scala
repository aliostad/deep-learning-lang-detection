import java.net.InetSocketAddress

import play.sbt.PlayRunHook
import sbt._

object Npm {
  def apply(): PlayRunHook = {

      object NpmProcess extends PlayRunHook {

        var watchProcess: Option[Process] = None

        override def beforeStarted(): Unit = {
          Process("npm run build").run
        }

        override def afterStarted(addr: InetSocketAddress): Unit = {
          watchProcess = Some(Process("npm run watch").run)
        }

        override def afterStopped(): Unit = {
          watchProcess.map(p => p.destroy())
          watchProcess = None
        }
      }

      NpmProcess
    }
}
