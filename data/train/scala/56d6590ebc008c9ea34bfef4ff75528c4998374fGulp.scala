import play.sbt.PlayRunHook
import sbt._

object Gulp {
  def apply(base: File, tasks: String): PlayRunHook = {

    object GulpProcess extends PlayRunHook {

      var process: Option[Process] = None

      override def beforeStarted(): Unit = {
        process = Some(runGulp())
      }

      private def runGulp(): Process = {
        val process: ProcessBuilder = System.getProperty("os.name").startsWith("Windows") match {
          case true => Process("cmd" :: "/c" :: "gulp" :: "--gulpfile=gulpfile.js" :: tasks.split(" ").toList, base)
          case _ => Process("gulp" :: "--gulpfile=gulpfile.js" :: tasks.split(" ").toList, base)
        }
        process.run()
      }

      override def afterStopped(): Unit = {
        process.map(p => p.destroy())
        process = None
      }
    }

    GulpProcess
  }
}