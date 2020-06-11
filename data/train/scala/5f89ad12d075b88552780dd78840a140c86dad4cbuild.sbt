name := "ccmach"

organization := "org.landonf"

version := "1.0"

scalaVersion := "2.11.7"

libraryDependencies ++= Seq(
  "org.scala-lang.modules"  %% "scala-parser-combinators" % "1.0.4",
  "org.scalaz"              %% "scalaz-core"              % "7.1.3",
  "org.typelevel"           %% "scalaz-specs2"            % "0.3.0"   % "test",
  "org.specs2"              %% "specs2-core"              % "2.4.6"   % "test"
)

scalacOptions ++= Seq(
    "-unchecked",
    "-deprecation",
    "-Xlint",
    "-Ywarn-dead-code",
    "-Xfatal-warnings",
    "-language:_",
    "-target:jvm-1.7",
    "-encoding", "UTF-8"
)

/* Request that SBT manage scaladoc API URL mappings for cross-library
 * linking */
autoAPIMappings := true

