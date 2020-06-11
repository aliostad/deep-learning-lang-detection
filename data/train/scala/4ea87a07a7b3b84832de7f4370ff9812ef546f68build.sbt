name := "simple-is-good"

version := "1.0"

scalaVersion := "2.10.4"

resolvers += "Local Maven Repository" at "file://"+Path.userHome.absolutePath+"/.m2/repository"

libraryDependencies ++= Seq(
  "org.apache.spark" %% "spark-core" % "1.2.0" % "provided",
  "org.apache.commons" % "commons-lang3" % "3.4",
  "org.apache.lucene" % "lucene-core" % "4.8.1",
  "org.apache.lucene" % "lucene-analyzers-common" % "4.8.1"
)

assemblyMergeStrategy in assembly := {
  case PathList("org", "tartarus", "snowball", xs @ _*)         => MergeStrategy.first
  case x =>
    val oldStrategy = (assemblyMergeStrategy in assembly).value
    oldStrategy(x)
}
