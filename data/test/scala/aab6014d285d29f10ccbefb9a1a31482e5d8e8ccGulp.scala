import play.PlayRunHook
import sbt._

import java.net.InetSocketAddress

object Gulp {

  def apply(base: File): PlayRunHook = {

    object GulpProcess extends PlayRunHook {
    
      var process: Option[Process] = None
      
      override def afterStarted(addr: InetSocketAddress): Unit = {
        process = Some(Process("node node_modules/gulp/bin/gulp.js watch", base).run)
      }

      override def afterStopped(): Unit = {
        process.map(p => p.destroy())
        process = None
      }
      
    }

    GulpProcess
  }
}