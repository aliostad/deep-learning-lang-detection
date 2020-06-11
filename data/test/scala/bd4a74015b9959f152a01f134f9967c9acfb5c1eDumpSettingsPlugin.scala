package sbtdumpsettings

import sbt._, Keys._
import java.io.File

object DumpSettingsPlugin extends sbt.AutoPlugin {
  type DumpSettingsKey = DumpSettingsKey.Entry[_]

  override def requires = plugins.JvmPlugin
  override def projectSettings: Seq[Def.Setting[_]] =
    dumpSettingsScopedSettings(Compile) ++ dumpSettingsDefaultSettings

  object autoImport extends DumpSettingsKeys {
    val DumpSettingsKey = sbtdumpsettings.DumpSettingsKey
    type DumpSettingsKey = sbtdumpsettings.DumpSettingsKey

    val addDumpSettingsToConfig = dumpSettingsScopedSettings _

    val dumpSettingsValues: TaskKey[Seq[DumpSettingsResult]] =
      taskKey("DumpSettings keys/values/types for use in the sbt build")
  }
  import autoImport._

  def buildNumberTask(dir: File, increment: Int): Int = {
    val file: File = dir / "dumpsettings.properties"
    val prop = new java.util.Properties

    def readProp: Int = {
      prop.load(new java.io.FileInputStream(file))
      prop.getProperty("buildnumber", "0").toInt
    }
    def writeProp(value: Int) {
      prop.setProperty("buildnumber", value.toString)
      prop.store(new java.io.FileOutputStream(file), null)
    }
    val current = if (file.exists) readProp
    else 0
    writeProp(current + increment)
    current
  }

  def dumpSettingsScopedSettings(conf: Configuration): Seq[Def.Setting[_]] = inConfig(conf)(Seq(
    dumpSettings :=
      DumpSettings(
        { baseDirectory.value },
        dumpSettingsRenderers.value,
        dumpSettingsKeys.value,
        thisProjectRef.value,
        state.value,
        streams.value.cacheDirectory
      ),
    dumpSettingsValues :=
      DumpSettings.results(dumpSettingsKeys.value, thisProjectRef.value, state.value),
    resourceGenerators ++= {
      Seq(dumpSettings.taskValue)
    },
    dumpSettingsRenderers := Seq(BashRenderer(), JsonRenderer())
  ))

  def dumpSettingsDefaultSettings: Seq[Setting[_]] = Seq(
    dumpSettingsKeys := Seq(name, version, scalaVersion, sbtVersion),
    dumpSettingsBuildNumber := buildNumberTask(baseDirectory.value, 1),
    dumpSettingsRenderers := Seq(BashRenderer(), JsonRenderer())
  )
}
