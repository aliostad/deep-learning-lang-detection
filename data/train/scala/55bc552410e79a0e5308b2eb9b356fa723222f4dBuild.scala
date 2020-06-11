import sbt._,Keys._

object Build extends Build {
  lazy val baseSettings = Seq(
    scalaVersion := "2.10.1",
    organization := "com.github.hexx",
    scalacOptions ++= Seq("-deprecation", "-feature", "-unchecked"),
    scalacOptions ++= Seq("-language:higherKinds"),
    libraryDependencies += "org.scalaz" %% "scalaz-core" % "7.0.0-M9",
    initialCommands in console += Seq(
      "scalaz._",
      "Scalaz._",
      "com.github.hexx.bound._"
    ).map("import " + _ + "\n").mkString
  )

  lazy val bound = Project(
    id = "bound",
    base = file(".")
  ).settings(
    baseSettings ++ seq(
      name := "bound",
      version := "0.0.1"
    ) : _*
  )

  lazy val examples = Project(
    id = "examples",
    base = file("examples")
  ).settings(
    baseSettings ++ seq(
      libraryDependencies ++= Seq(
        "com.github.hexx" %% "bound" % "0.0.1"
      )
    ) : _*
  ).dependsOn(bound)

  lazy val oldSolutions = Project(
    id = "old-solutions",
    base = file("old-solutions")
  ).settings(
    baseSettings : _*
  )
}
