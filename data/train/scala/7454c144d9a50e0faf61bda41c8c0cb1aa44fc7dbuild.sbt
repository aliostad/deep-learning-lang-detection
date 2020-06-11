import AssemblyKeys._

Statika.distributionProject

name := "bayenv"
description := ""
organization := "ohnosequences"
scalaVersion := "2.10.4"

libraryDependencies ++= Seq(
  "ohnosequences" %% "nisperito" % "1.1.0-SNAPSHOT"
)

metadataObject := name.value

// dependencyOverrides += "ohnosequences" %% "aws-statika" % "1.0.1"

mergeStrategy in assembly <<= (mergeStrategy in assembly) { (old) => {
    case "about.html" => MergeStrategy.first
    case x if x endsWith "plugin.properties" => MergeStrategy.first
    case x => old(x)
  }
}

s3overwrite := true
