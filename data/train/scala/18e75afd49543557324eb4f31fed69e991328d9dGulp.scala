import play.PlayRunHook
import sbt._

import java.net.InetSocketAddress

object Gulp {
  def apply(base: File): PlayRunHook = {

    object GulpProcess extends PlayRunHook {

      var process: Option[Process] = None

//      override def beforeStarted(): Unit = {
//        Process("gulp build", base).run
//        //TODO: fix for Windows, can't detect gulp off my PATH, must use this hard-coded crap below, wtf.
////        Process("C:/Users/T/AppData/Roaming/npm/gulp.cmd build", base).run
//      }

      // override def afterStarted(addr: InetSocketAddress): Unit = {
      //   process = Some(Process("gulp watch", base).run)
      // }
      //
      // override def afterStopped(): Unit = {
      //   process.map(p => p.destroy())
      //   process = None
      // }
    }

    GulpProcess
  }
}
