seq(appbundle.settings: _*)

name           := "MyScalaColliderApp"

version        := "0.1"

organization   := "doe.john"

scalaVersion   := "2.9.1"

libraryDependencies ++= Seq(
   "de.sciss" %% "scalacollider" % "0.33"
)

//retrieveManaged := true

scalacOptions ++= Seq( "-deprecation", "-unchecked" )

// ---- packaging ----

appbundle.name := "MyScalaColliderApp"

appbundle.javaOptions += "-Xmx1024m"

appbundle.javaOptions ++= Seq( "-ea" )

appbundle.systemProperties += "SC_HOME" -> "Contents/Resources/scsynth"

appbundle.resources ++= {
   val oldBase = file( "scsynth" ) / "build" / "Install" / "SuperCollider"
   val newBase = oldBase / "SuperCollider.app" / "Contents" / "Resources"
   if( (oldBase / "scsynth").exists ) {
      val scsynth = oldBase / "scsynth"
      val plugins = oldBase / "plugins"
      val lib1    = oldBase / "libscsynth.1.0.0.dylib"
      val lib2    = oldBase / "libscsynth.1.dylib"
      val lib3    = oldBase / "libscsynth.dylib"
      Seq( scsynth, plugins, lib1, lib2, lib3 )
   } else {
      val scsynth = newBase / "scsynth"
      require( scsynth.exists, "SuperCollider installation not found" )
      val plugins = newBase / "plugins"
      val lib1    = newBase / "SCClassLibrary"
      Seq( scsynth, plugins, lib1 )
   }
}

appbundle.workingDirectory := Some( file( appbundle.BundleVar_AppPackage ))

appbundle.icon := Some( file( "icon.png" ))
