import java.net.InetSocketAddress
import play.sbt.PlayRunHook
import sbt._

object Webpack {
  println(System.getenv("PATH"))


  def apply(base: File): PlayRunHook = {
    object WebpackHook extends PlayRunHook {

      var process: Option[Process] = None

      override def beforeStarted() = {
        process = Option(
          Process("webpack.cmd", base).run()
        )
      }

      override def afterStarted(addr: InetSocketAddress) = {
        process = Option(
          Process("webpack.cmd --watch", base).run()
        )
      }

      override def afterStopped() = {
        process.foreach(_.destroy())
        process = None
      }
    }

    WebpackHook
  }
}