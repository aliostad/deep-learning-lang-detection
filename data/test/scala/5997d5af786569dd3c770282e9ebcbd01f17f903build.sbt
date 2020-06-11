name := "dynamy.manager"

libraryDependencies += "org.osgi" % "org.osgi.core" % "4.3.0" % "provided"

libraryDependencies += "org.osgi" % "org.osgi.compendium" % "4.3.0" % "provided"

libraryDependencies += "org.slf4j" % "slf4j-api" % "1.7.2" % "provided"

libraryDependencies += "org.apache.shiro" % "shiro-core" % "1.2.1"

libraryDependencies += "ru.circumflex" % "circumflex-web" % "2.5"

libraryDependencies += "ru.circumflex" % "circumflex-ftl" % "2.5"

version := "1.0.0"

osgiSettings

OsgiKeys.importPackage := Seq("org.eclipse.jetty.*;version=\"[8.0,9)\"","*")

OsgiKeys.privatePackage := Seq("dynamy.manager.*")

OsgiKeys.additionalHeaders := Map("Web-ContextPath" -> "manage")

OsgiKeys.embeddedJars <<= Keys.externalDependencyClasspath in Compile map {
  deps => deps filter (d => d.data.getName startsWith "circumflex") map (d => d.data)
}

publishTo := Some(Resolver.file("file",  new File("/home/iamedu/Development/just-cloud/dynamy-bundles")))


