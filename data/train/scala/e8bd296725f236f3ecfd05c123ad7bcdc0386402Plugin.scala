package sbtuniqueversion

import sbt._
import Keys._

object Plugin extends Plugin {
  object UniqueVersionKeys {
    lazy val uniqueVersion = settingKey[Boolean]("Enables unique version.")
    lazy val ivyStatus = settingKey[IvyStatus]("Status of the build.")
  }

  import UniqueVersionKeys._

  trait IvyStatus
  case object IvyStatus {
    case object Integration extends IvyStatus { override def toString: String = "integration" }
    case object Milestone extends IvyStatus { override def toString: String = "milestone" }
    case object Release extends IvyStatus { override def toString: String = "release" }
  }

  private def replaceModule(m: ModuleID): ModuleID = m.copy(revision = replaceVersion(m.revision))
  private def replaceVersion(v: String): String = """SNAPSHOT$""".r.replaceFirstIn(v, uniqueString)
  private def uniqueString: String = {
    import java.{util => ju}
    val sf = new java.text.SimpleDateFormat("yyyyMMdd-HHmmss")
    sf.setTimeZone(ju.TimeZone.getTimeZone("UTC"))
    sf.format(new ju.Date())
  }

  lazy val uniqueVersionSettings: Seq[Def.Setting[_]] = Seq(
    uniqueVersion := false,
    ivyStatus := { if(isSnapshot.value) IvyStatus.Integration else IvyStatus.Release },
    moduleSettings := {
      val old = moduleSettings.value
      if(uniqueVersion.value && isSnapshot.value)
        old match {
          case ic: InlineConfiguration =>
            new InlineConfiguration(replaceModule(ic.module), ic.moduleInfo, ic.dependencies, ic.overrides, ic.ivyXML, ic.configurations,
              ic.defaultConfiguration, ic.ivyScala, ic.validate)
          case _ => old
        }
      else old
    },
    deliverLocalConfiguration := {
      val old = deliverLocalConfiguration.value
      new DeliverConfiguration (old.deliverIvyPattern, ivyStatus.value.toString, old.configurations, old.logging)
    },
    deliverConfiguration := {
      val old = deliverConfiguration.value
      new DeliverConfiguration (old.deliverIvyPattern, ivyStatus.value.toString, old.configurations, old.logging)
    }
  )

  implicit class RichModuleID(val m: ModuleID) extends AnyVal {
    def latestIntegration: ModuleID = m.copy(revision = "latest.integration")
    def latestMilestone: ModuleID = m.copy(revision = "latest.milestone")
    def latestRelease: ModuleID = m.copy(revision = "latest.release") 
  }
}
