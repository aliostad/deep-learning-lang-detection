load.ivy("com.lihaoyi" %% "ammonite-shell" % ammonite.Constants.version)
@
val sess = ammonite.shell.ShellSession()
import sess._
import ammonite.shell.PPrints._
import ammonite.ops._
import ammonite.shell._
ammonite.shell.Configure(repl, wd)



load.ivy("org.scalaz" %% "scalaz-core" % "7.1.1")
load.ivy("org.scalaj" %% "scalaj-http" % "2.2.0")
load.ivy("org.jsoup" % "jsoup" % "1.8.3")
load.ivy( "org.apache.spark" % "spark-core_2.11" % "1.6.0")
@
import scalaj.http.Http
import org.jsoup.Jsoup
import scala.collection.JavaConverters._
import ammonite.ops._

implicit class AdditionalLoads(load: ammonite.repl.frontend.Load) {
  def spark = load.module(home/".ammonite"/"spark.scala")
  def kafka = load.module(home/".ammonite"/"kafka.scala")
}

implicit val path = cwd
