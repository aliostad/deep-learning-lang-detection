import java.net.InetSocketAddress

import play.sbt.PlayRunHook
import sbt._

class FrontendWatch(base: File) {

  def hook(): PlayRunHook = {

    object WatchProcess extends PlayRunHook {

      var watchProcess: Option[Process] = None

      override def afterStarted(addr: InetSocketAddress): Unit = {
        watchProcess = Some(Process("yarn run dev-watch", base).run)
      }

      override def afterStopped(): Unit = {
        watchProcess.foreach(p => p.destroy())
        watchProcess = None
      }
    }

    WatchProcess
  }
}

object FrontendWatch {
  def apply(base: File): FrontendWatch = new FrontendWatch(base)
}