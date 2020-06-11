
name := "premier"

version := "1.0"

scalaVersion := "2.10.1"

EclipseKeys.withSource := true

// Maven repo included by default

resolvers += "Typesafe Repository" at "http://repo.typesafe.com/typesafe/releases/"

resolvers += "conjars.org" at "http://conjars.org/repo"

// TODO - smarter way to manage dependencies? (previous akka-actor was only for 2.9.2 but this showed up as noSuchMethod for Duration
libraryDependencies += "com.typesafe.akka" % "akka-actor_2.10" % "2.2-M3"

// libraryDependencies += "com.twitter" %% "scalding" % "0.8.3"

// libraryDependencies += "org.scalatest" % "scalatest_2.10.0" % "1.8"

// libraryDependencies += "net.databinder.dispatch" % "dispatch-core_2.10" % "0.10.0"

// libraryDependencies += "org.apache.commons" % "commons-io" % "1.3.2"
