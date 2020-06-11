package com.imaginea.activegrid.core.models

/**
 * Created by ranjithrajd on 4/11/16.
 */
sealed trait SoftwareProcess {
  def name: String

  override def toString: String = super.toString
}

object SoftwareProcess {

  case object NginxProcess extends SoftwareProcess {
    override def name: String = "nginx"
  }

  case object GraphiteProcess extends SoftwareProcess {
    override def name: String = "graphite"
  }

  case object Apache2Process extends SoftwareProcess {
    override def name: String = "apache2"
  }

  case object ApacheProcess extends SoftwareProcess {
    override def name: String = "apache"
  }

  case object CollectDProcess extends SoftwareProcess {
    override def name: String = "collectd"
  }

  case object RubyProcess extends SoftwareProcess {
    override def name: String = "ruby"
  }

  case object MysqlDProcess extends SoftwareProcess {
    override def name: String = "mysqld"
  }

  case object MysqlProcess extends SoftwareProcess {
    override def name: String = "mysql"
  }

  case object JavaProcess extends SoftwareProcess {
    override def name: String = "java"
  }

  case object PythonProcess extends SoftwareProcess {
    override def name: String = "python"
  }

  case object NoOpt extends SoftwareProcess {
    override def name: String = ""
  }

  val getAllProcess: List[SoftwareProcess] =
    JavaProcess :: MysqlDProcess :: MysqlProcess ::
      RubyProcess :: CollectDProcess ::
      ApacheProcess :: Apache2Process :: PythonProcess :: NginxProcess :: Nil

  def isKnownProcess(processName: String): Boolean = getAllProcess.contains(toProcessType(processName))

  def toProcessType(process: String): SoftwareProcess = {
    process match {
      case "nginx" => NginxProcess
      case "graphite" => GraphiteProcess
      case "apache2" => Apache2Process
      case "apache" => ApacheProcess
      case "collectd" => CollectDProcess
      case "ruby" => RubyProcess
      case "mysqld" => MysqlDProcess
      case "mysql" => MysqlProcess
      case "java" => JavaProcess
      case "python" => PythonProcess
      case _ => NoOpt
    }
  }
}

trait KnownSoftware {
  val name: String
  val provider: String
  val process: List[SoftwareProcess]
  val discoverApplications: Boolean
  val applicationDiscoveryHelper: Option[ApplicationDiscovery]
}

object KnownSoftware {
  val getStartUpClazzMap = Map("com.pramati.Server" -> PServer, "org.apache.catalina.startup.Bootstrap" -> Tomcat)

  case object Tomcat extends KnownSoftware {
    override val name: String = "Tomcat"
    override val applicationDiscoveryHelper: Option[ApplicationDiscovery] = Some(TomcatApplicationDiscovery)
    override val provider: String = "Apache Software Foundation"
    override val process: List[SoftwareProcess] = List(SoftwareProcess.JavaProcess)
    override val discoverApplications: Boolean = true
  }

  case object Apache extends KnownSoftware {
    override val name: String = "Apache"
    override val applicationDiscoveryHelper: Option[ApplicationDiscovery] = None
    override val provider: String = "Apache Software Foundation"
    override val process: List[SoftwareProcess] = List(SoftwareProcess.ApacheProcess, SoftwareProcess.Apache2Process)
    override val discoverApplications: Boolean = false
  }

  case object Mysql extends KnownSoftware {
    override val name: String = "Mysql"
    override val applicationDiscoveryHelper: Option[ApplicationDiscovery] = None
    override val provider: String = "Oracle Corporation"
    override val process: List[SoftwareProcess] = List(SoftwareProcess.MysqlDProcess, SoftwareProcess.MysqlProcess)
    override val discoverApplications: Boolean = false
  }

  case object PServer extends KnownSoftware {
    override val name: String = "PServer"
    override val applicationDiscoveryHelper: Option[ApplicationDiscovery] = None
    override val provider: String = "Pramati Technologies"
    override val process: List[SoftwareProcess] = List(SoftwareProcess.JavaProcess)
    override val discoverApplications: Boolean = true
  }

  case object Nginx extends KnownSoftware {
    override val name: String = "Nginx"
    override val applicationDiscoveryHelper: Option[ApplicationDiscovery] = None
    override val provider: String = "Nginx, Inc"
    override val process: List[SoftwareProcess] = List(SoftwareProcess.NginxProcess)
    override val discoverApplications: Boolean = false
  }

  case object Graphite extends KnownSoftware {
    override val name: String = "Graphite"
    override val applicationDiscoveryHelper: Option[ApplicationDiscovery] = None
    override val provider: String = "Graphite"
    override val process: List[SoftwareProcess] = List(SoftwareProcess.GraphiteProcess)
    override val discoverApplications: Boolean = false
  }

  def toSoftwareType(software: String): KnownSoftware = {
    software match {
      case "Nginx" => Nginx
      case "Graphite" => Graphite
      case "PServer" => PServer
      case "Mysql" => Mysql
      case "Tomcat" => Apache
    }
  }
}

trait ApplicationDiscovery {
  def discoverApplications(pid: String, sshSession: SSHSession1): Set[String]
}

case object TomcatApplicationDiscovery extends ApplicationDiscovery {
  override def discoverApplications(pid: String, sshSession: SSHSession1): Set[String] = ???
}

