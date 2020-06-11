import sbt._
import Keys._

object Grunt extends Build {
  var buildProcess: Option[Process] = None
  var watchProcess: Option[Process] = None

  val webPath = Path("./src/main/web").asFile

  def runBuild = {
    Process("npm install", webPath).!
    Process("bower install", webPath).!

    buildProcess = Some(Process("grunt build", webPath).run())
    buildProcess.get.exitValue()
    buildProcess = None
  }

  def runWatch = {
    if (Grunt.watchProcess.isDefined) Grunt.watchProcess.get.destroy()

    val gruntRebuild = Process("grunt rebuild", webPath).run()
    Grunt.watchProcess = Some(gruntRebuild)
  }

}
