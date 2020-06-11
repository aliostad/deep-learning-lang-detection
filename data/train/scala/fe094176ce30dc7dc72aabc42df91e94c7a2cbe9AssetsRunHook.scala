import java.net.InetSocketAddress

import play.sbt.PlayRunHook
import sbt._

object AssetsRunHook {
  def apply(base: File): PlayRunHook = {
    val frontEndBase = new File(base, "front-end")

    object AssetsProcess extends PlayRunHook {
      var gulpProcess: Option[Process] = None
      var webpackProcess: Option[Process] = None

      override def beforeStarted(): Unit = {
        //        Process("./node_modules/.bin/gulp build", frontEndBase).run()
        //        Process("./node_modules/.bin/webpack", frontEndBase).run()
        Process("npm install").run()
      }

      override def afterStarted(addr: InetSocketAddress): Unit = {
        gulpProcess = Some(Process("./node_modules/.bin/gulp watch", frontEndBase).run())
        webpackProcess = Some(Process("./node_modules/.bin/webpack --watch", frontEndBase).run())
        // TODO 当gulp watch失败时怎样重复执行？
        if (gulpProcess.get.exitValue() != 0) {
          gulpProcess = Some(Process("./node_modules/.bin/gulp watch", frontEndBase).run())
        }
      }

      override def afterStopped(): Unit = {
        gulpProcess.foreach(_.destroy())
        webpackProcess.foreach(_.destroy())
        gulpProcess = None
        webpackProcess = None
      }
    }

    AssetsProcess
  }
}
