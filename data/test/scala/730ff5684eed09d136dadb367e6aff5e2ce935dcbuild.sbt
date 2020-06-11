import AssemblyKeys._ // put this at the top of the file

assemblySettings

organization := "ibuenros.mllibdemos"

name := "MLlibDemos"

version := "1.0"

scalaVersion := "2.10.4"

libraryDependencies ++= Seq(
  "org.apache.spark" %% "spark-core" % "1.0.2" % "provided",
  "org.apache.spark" %% "spark-streaming" % "1.0.2" % "provided",
  "org.apache.spark" %% "spark-mllib" % "1.0.2" % "provided"
)

resolvers += "Akka Repository" at "http://repo.akka.io/releases/"

// This is a nasty hack.
mergeStrategy in assembly <<= (mergeStrategy in assembly) { (old) =>
{
  case x => {
    val oldstrat = old(x)
    if (oldstrat == MergeStrategy.deduplicate) MergeStrategy.first
    else oldstrat
  }
}
}