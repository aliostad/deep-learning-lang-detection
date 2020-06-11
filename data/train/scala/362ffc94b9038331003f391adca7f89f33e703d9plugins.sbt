resolvers += Classpaths.sbtPluginReleases

resolvers += Classpaths.typesafeReleases

// Add the following to have Git manage your build versions
resolvers += "jgit-repo" at "http://download.eclipse.org/jgit/maven"

addSbtPlugin("com.typesafe.sbt" % "sbt-git" % "0.6.4")

// addSbtPlugin("org.scoverage" %% "sbt-scoverage" % "1.0.1")

// addSbtPlugin("org.scoverage" % "sbt-coveralls" % "1.0.0.BETA1")

addSbtPlugin("org.scoverage" %% "sbt-scoverage" % "0.99.7.1")

addSbtPlugin("com.sksamuel.scoverage" %% "sbt-coveralls" % "0.0.5")
