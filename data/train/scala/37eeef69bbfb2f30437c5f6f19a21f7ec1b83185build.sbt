name := "scala-spark"

version := "1.0"

scalaVersion := "2.10.5"

libraryDependencies ++= Seq(
  "org.apache.spark" % "spark-core_2.10" % "1.3.1",
  "org.apache.spark" % "spark-sql_2.10" % "1.3.1"
)

//addSbtPlugin("com.eed3si9n" % "sbt-assembly" % "0.13.0")

// Only include if using assembly
/*
mergeStrategy in assembly <<= (mergeStrategy in assembly) { (old) => {
  case PathList("javax", "servlet", xs@_*) =>
    MergeStrategy.first
  case PathList("org", "apache", xs@_*) => MergeStrategy.first
  case "about.html" => MergeStrategy.rename
  case x => old(x)
}
}*/
