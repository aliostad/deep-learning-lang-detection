import sbt._
import Process._
import Keys._

lazy val common_settings = Seq(
	organization	:= "kakao",
	version		:= "0.0.0",
	scalaVersion	:= "2.11.7",
	scalacOptions	:= Seq("-deprecation", "-encoding", "utf8", "-feature")
)

lazy val webspider = (project in file("."))
	.settings(common_settings: _*)
	.settings(
		name		:= "webspider",
		//unmanagedBase	:= baseDirectory / "lib",	//local libs manage
		libraryDependencies ++= Seq(
			"org.quartz-scheduler"	%	"quartz"		%	"2.2.3",
			"com.typesafe"		%	"config"		%	"1.3.0",
			"org.postgresql"	%	"postgresql"		%	"9.4-1201-jdbc41",
			"us.codecraft"		%	"webmagic-core"		%	"0.5.3",
			"us.codecraft"		%	"webmagic-extension"	%	"0.5.3"
		)
	)
