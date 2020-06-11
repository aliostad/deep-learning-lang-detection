import sbt._
import Keys._
import com.github.shivawu.sbt.maven.MavenBuild
import sbtassembly.Plugin._
import AssemblyKeys._

object Build extends MavenBuild {
    project("*")(Seq(
      crossVersion := CrossVersion.Disabled
    ):_*)

    project("bronto-api-app") (assemblySettings ++ Seq(
      libraryDependencies += "com.sun.xml.ws" % "jaxws-rt" % "2.1.4",
      fork in (Compile, run) := true,
      connectInput in (Compile, run) := true,
      javaOptions in (Compile, run) ++= Seq(
        "-Dcom.sun.xml.ws.transport.http.client.HttpTransportPipe.dump=true",
        "-Dcom.sun.xml.internal.ws.transport.http.client.HttpTransportPipe.dump=true",
        "-Dcom.sun.xml.ws.transport.http.HttpAdapter.dump=true",
        "-Dcom.sun.xml.internal.ws.transport.http.HttpAdapter.dump=true"
      )
    ):_*)
}
