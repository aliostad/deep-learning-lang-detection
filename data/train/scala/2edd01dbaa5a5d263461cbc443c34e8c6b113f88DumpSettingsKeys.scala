package sbtdumpsettings

import sbt._
import Keys._

trait DumpSettingsKeys {
  lazy val dumpSettings = taskKey[Seq[File]]("The task that generates the build info.")
  lazy val dumpSettingsRenderers = settingKey[Seq[DumpSettingsRenderer]]("The renderers to use to generate the build info.")
  //lazy val dumpSettingsRenderer      = settingKey[DumpSettingsRenderer]("The renderer to use to generate the build info.")
  //lazy val dumpSettingsRenderFactory = settingKey[DumpSettingsRenderer.Factory]("The renderFactory to used to build the renderer.")
  lazy val dumpSettingsKeys = settingKey[Seq[DumpSettingsKey.Entry[_]]]("Entries for build info.")
  lazy val dumpSettingsBuildNumber = taskKey[Int]("The build number.")
}
object DumpSettingsKeys extends DumpSettingsKeys
