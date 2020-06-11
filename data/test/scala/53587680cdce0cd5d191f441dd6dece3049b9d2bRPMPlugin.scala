package com.trafficland.augmentsbt.rpm

import java.nio.charset.Charset

import com.trafficland.augmentsbt.rpm.Keys._
import com.typesafe.sbt.SbtNativePackager._
import com.typesafe.sbt.packager.Keys._
import com.typesafe.sbt.packager.archetypes.{JavaServerAppPackaging, TemplateWriter}
import com.typesafe.sbt.packager.linux.{LinuxMappingDSL, LinuxSymlink}
import com.typesafe.sbt.packager.rpm.RpmPlugin.autoImport.RpmConstants._
import com.typesafe.sbt.packager.rpm.{RpmKeys, RpmPlugin}
import sbt.Keys._
import sbt._

import scala.util.control.Exception.nonFatalCatch

object RPMPlugin extends AutoPlugin with RpmKeys with LinuxMappingDSL {

  override def requires: Plugins = RpmPlugin && JavaServerAppPackaging

  object Names {
    val ManageDaemonAccounts = "manage_daemon_accounts"
  }

  override lazy val projectSettings: Seq[Def.Setting[_]] =
    Seq(
      name in Rpm <<= name apply { n => n },
      linuxPackageSymlinks <<= (installationDirectory, rpmVendor, name in Rpm) map { (installationDir, v, n) =>
          val vendorName = s"$v/$n"
          Seq(
            LinuxSymlink(s"$installationDir/logs", s"/var/log/$vendorName"),
            LinuxSymlink(s"/etc/$vendorName", s"$installationDir/conf")
          )
      },
      linuxPackageMappings <+= (installationDirectory, baseDirectory) map { (installationDir, baseDir) =>
        packageMapping(baseDir -> s"$installationDir/conf")
      },
      version in Rpm <<= version apply { v => v.replace("-", "") },
      rpmLicense := Some("Proprietary"),
      rpmGroup := Some("Applications/Services"),
      rpmRelease := "1",
      linuxUserAndGroup := ("nobody", "nobody"),
      vendorDirectory <<= rpmVendor apply { rv => "/opt/" + rv },
      installationDirectory <<= (vendorDirectory, destinationDirectory) apply { (vd, dd) => vd + Path.sep + dd },
      destinationDirectory <<= (name in Rpm) apply { n => n }
    ) ++ inConfig(Rpm)(Seq(
      manageDaemonAccounts := false,
      scriptTemplates in Rpm := defaultScriptTemplates(getClass.getResource("")),
      linuxScriptReplacements <+= manageDaemonAccounts {
        Names.ManageDaemonAccounts -> _.toString
      },
      maintainerScripts in Rpm := {
        val scripts = makeMaintainerScripts(scriptTemplates.value, linuxScriptReplacements.value)
        if (rpmBrpJavaRepackJars.value) {
          val pre = scripts.getOrElse(Pre, Nil)
          val skipRepackScript = IO.readStream(skipRepackScriptResource.openStream, Charset.forName("UTF-8"))
          scripts + (Pre -> (pre :+ skipRepackScript))
        } else {
          scripts
        }
      }
    ))

  def defaultScriptTemplates(path: URL): Map[String, URL] = {
    val predefined = Seq(Pre, Post, Preun, Postun)
    predefined.foldLeft(Map.empty[String, URL]) { (scripts, name) =>
      Option(new URL(path, s"$name-template")).collect {
        case script if nonFatalCatch.opt(script.openConnection()).isDefined =>
          scripts + (name -> script)
      }.getOrElse(scripts)
    }
  }

  def skipRepackScriptResource: java.net.URL = RpmPlugin.getClass.getResource("brpJavaRepackJar")

  def makeMaintainerScripts(templates: Map[String, URL], replacements: Seq[(String, String)]): Map[String, Seq[String]] = {
    templates.mapValues { url =>
      TemplateWriter.generateScript(url, replacements) :: Nil
    }
  }
}