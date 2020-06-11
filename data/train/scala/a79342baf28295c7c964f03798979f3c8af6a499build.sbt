import AssemblyKeys._

name := "lifewar"

version := "0.1-SNAPSHOT"

organization := "com.github.mvallerie"

scalaVersion := "2.10.2"

scalacOptions += "-deprecation"

// Old way ?

seq(scageSettings: _*)

seq(assemblySettings: _*)

// TODO Temporary way. Jogg jar from B2S repo is crappy
excludedJars in assembly <<= (fullClasspath in assembly) map { cp => 
  cp filter {_.data.getName == "jogg-0.0.7.jar"}
}

// TODO : logback.xml ?
mergeStrategy in assembly <<= (mergeStrategy in assembly) { (old) =>
	{
		case "maven.properties" => MergeStrategy.first
    		case PathList("resources", xs @ _*) => MergeStrategy.first
		case x => old(x)
	}
}
