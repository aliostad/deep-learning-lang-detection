import sbt.Keys._

val AkkaVersion = "2.4.9-RC2"
val PlayVersion = "2.5.0"
val SlickVersion = "3.1.1"
val HikariVersion = "2.4.7"
val Angular2Version = "2.0.0-rc.4"
val log4j2Version = "2.6.2"

lazy val commonSettings = Seq(
  organization := "com.wex",
  version := "0.1.0",
  scalaVersion := "2.11.8",
  libraryDependencies ++= Seq(
    "com.typesafe.akka" %% "akka-stream" % AkkaVersion,
    "com.typesafe.akka" %% "akka-http-core" % AkkaVersion,
    "com.typesafe.akka" %% "akka-http-experimental" % AkkaVersion,
    "com.typesafe.akka" %% "akka-http-spray-json-experimental" % AkkaVersion,
    "com.typesafe.akka" %% "akka-slf4j" % AkkaVersion,
    "com.typesafe.play" %% "play-ws" % PlayVersion,
    "com.typesafe.slick" %% "slick-hikaricp" % SlickVersion,
    "mysql" % "mysql-connector-java" % "5.1.38",
    "com.zaxxer" % "HikariCP" % HikariVersion,
    "org.slf4j" % "slf4j-nop" % "1.6.4",
    //    "org.webjars.npm" % "angular__common" % Angular2Version,
    //    "org.webjars.npm" % "angular__core" % Angular2Version,
    //    "org.webjars.npm" % "angular__http" % Angular2Version,
    //    "org.webjars.npm" % "angular__platform-browser" % Angular2Version,
    //    "org.webjars.npm" % "angular__platform-browser-dynamic" % Angular2Version,
    //    "org.webjars.npm" % "angular__upgrade" % Angular2Version,
    //    "org.webjars.npm" % "angular__router" % "3.0.0-beta.2",
    //    "org.webjars.npm" % "angular__forms" % "0.2.0",
    //    "org.webjars.npm" % "angular2-in-memory-web-api" % "0.0.14",
    //    "org.webjars.npm" % "systemjs" % "0.19.31",
    //    "org.webjars.npm" % "core-js" % "2.4.0",
    //    "org.webjars.npm" % "reflect-metadata" % "0.1.3",
    //    "org.webjars.npm" % "rxjs" % "5.0.0-beta.10",
    //    "org.webjars.npm" % "zone.js" % "0.6.12",
    //    "org.webjars.npm" % "bootstrap" % "4.0.0-alpha.2",
    //    "org.webjars.npm" % "jquery" % "2.2.4",
    //    "org.webjars.npm" % "tether" % "1.3.2",
    "org.apache.logging.log4j" % "log4j-api" % log4j2Version,
    "org.apache.logging.log4j" % "log4j-core" % log4j2Version,
    "com.h2database" % "h2" % "1.4.192",
    ws,
    "com.jcraft" % "jsch" % "0.1.53",
    "org.apache.mina" % "mina-core" % "2.0.13",
    "org.apache.sshd" % "sshd-core" % "1.2.0"
    //    "com.typesafe.play" %% "play-slick" % "2.0.0",
    //    "com.typesafe.play" %% "play-slick-evolutions" % "2.0.0",
    //    jdbc
  )
)

lazy val master = (project in file("master")).
  settings(commonSettings: _*).
  settings(
    name := "master"
  ).enablePlugins(JavaAppPackaging)

lazy val agent = (project in file("agent")).
  settings(commonSettings: _*).
  settings(
    name := "agent"
  ).enablePlugins(JavaAppPackaging)

lazy val manage = (project in file("manage")).
  settings(commonSettings: _*).
  settings(
    name := "manage"
  ).enablePlugins(PlayScala)