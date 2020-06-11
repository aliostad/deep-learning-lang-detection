import play.sbt.PlayRunHook
import sbt._
import java.net.InetSocketAddress
import java.io.File

object Ng {
    def apply(): PlayRunHook = {

        object NgProcess extends PlayRunHook {

            var ngProcess: Option[Process] = None
            val frontend = new File(".")

            override def afterStarted(addr: InetSocketAddress): Unit = {
                // Run angular build in separate process in a waiting mode
                ngProcess = Some(Process("ng build -w -ec", frontend).run)
            }

            override def afterStopped(): Unit = {
                // Stop angular process
                ngProcess.foreach(p => p.destroy())
                ngProcess = None
            }
        }

        NgProcess

    }
}