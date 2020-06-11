name := "rabbitmq-manage"

licenses := Seq("MIT License" -> url("http://www.opensource.org/licenses/mit-license.php"))

resolvers += "typesafe" at "http://typesafe.artifactoryonline.com/typesafe/releases/"

scalaVersion := "2.11.6"

ivyScala := ivyScala.value map { _.copy(overrideScalaVersion = true) }

twentyThreeWithoutDependencies

TwentyThreeKeys.twentyThreeSetting :=
  play.twentythree.Settings.get((22 to 32).toList).copy(packageName = "rabbitmqmanage")

libraryDependencies ++= (
  ("com.typesafe.play" %% "play-json" % "2.3.8") ::
  ("com.github.xuwei-k" %% "httpz-native" % "0.2.17" % "test") ::
  ("com.chuusai" %% "shapeless" % "2.1.0") ::
  ("com.github.xuwei-k" %% "play-json-extra" % "0.2.3") ::
  Nil
)

scalacOptions ++= (
  "-deprecation" ::
  "-unchecked" ::
  "-Xlint" ::
  "-language:existentials" ::
  "-language:higherKinds" ::
  "-language:implicitConversions" ::
  Nil
)
