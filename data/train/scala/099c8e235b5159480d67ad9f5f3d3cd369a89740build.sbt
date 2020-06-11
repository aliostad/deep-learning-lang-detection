import sbtassembly.Plugin._
import AssemblyKeys._

name := "$name$"

version := "1.0"

organization := "$package$"

scalaVersion := "$scala$"

// scalacOptions ++= Seq("-unchecked", "-deprecation")

parallelExecution in Test := false

assemblySettings

test in assembly := {}

mergeStrategy in assembly ~= {
  (old) => {
    case m if m.contains("MANIFEST") => MergeStrategy.discard
    case m if m.contains("LICENSE")  => MergeStrategy.discard
    case m if m.contains("NOTICE")   => MergeStrategy.discard
    case "log4j.properties"          => MergeStrategy.discard
    case x => old(x)
  }
}
