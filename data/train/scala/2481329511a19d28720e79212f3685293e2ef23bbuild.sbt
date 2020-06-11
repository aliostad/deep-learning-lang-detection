import AssemblyKeys._

name := "familytree"

version := "0.1-SNAPSHOT"

scalaVersion := "2.10.3"

libraryDependencies += "org.apache.xmlgraphics" % "fop" % "1.1"

libraryDependencies += "org.gedcom4j" % "gedcom4j" % "2.1.2"

libraryDependencies += "org.apache.avalon.framework" % "avalon-framework-api" % "4.3.1"

libraryDependencies += "org.apache.avalon.framework" % "avalon-framework-impl" % "4.3.1"

assemblySettings

mainClass in assembly := Some("familytree.Cli")

mergeStrategy in assembly <<= (mergeStrategy in assembly) { (old) =>
  {
    case PathList("org", "w3c", "dom", xs @ _*) => MergeStrategy.first
    case x => old(x)
  }
}
