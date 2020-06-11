package trafficland.opensource.sbt.plugins.packagemanagement

import sbt._
import Keys._

object PackageManagementPlugin extends Plugin {

  lazy val plug = Seq(
    artifactName := { (sv: ScalaVersion, module: ModuleID, artifact: Artifact) =>
      artifact.name + "-" + artifact.`type` + "." + artifact.extension
    },
    artifact in packageBin in Compile <<= (artifact in packageBin in Compile, version) apply ( (old, ver) => {
      val newName = old.name + "-" + ver
      Artifact(newName, old.`type`, old.extension, old.classifier, old.configurations, old.url)
    }),
    artifact in packageSrc in Compile <<= (artifact in packageSrc in Compile, version) apply ( (old, ver) => {
      val newName = old.name + "-" + ver
      Artifact(newName, old.`type`, old.extension, old.classifier, old.configurations, old.url)
    }),
    artifact in packageDoc in Compile <<= (artifact in packageDoc in Compile, version) apply ( (old, ver) => {
      val newName = old.name + "-" + ver
      Artifact(newName, old.`type`, old.extension, old.classifier, old.configurations, old.url)
    })
  )
}