import java.io.File
import java.net._

import play.PlayRunHook
import sbt._

/**
 * Created by blackhorry on 10/14/14.
 */
object Grunt {
  def apply(base: File): PlayRunHook = {

    object GruntProcess extends PlayRunHook {

      var process: Option[Process] = None

      override def beforeStarted(): Unit = {
        println(s"++++ simplePlayRunHook.beforeStarted: $base")
//        Process("grunt init", base).run
        process = Some(Process("grunt", base).run)
      }

      override def afterStarted(addr: InetSocketAddress): Unit = {
        println(s"++++ simplePlayRunHook.afterStarted: $base")
//        process = Some(Process("grunt", base).run)
      }

      override def afterStopped(): Unit = {
        println("++++ simplePlayRunHook.afterStopped")
        process.map(p => p.destroy())
        process = None
      }
    }

    GruntProcess
  }
}
