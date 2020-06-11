package net.cosmo0920.irc.botConfig
import java.util.Properties
import scala.util.control.Exception._
import net.cosmo0920.irc.loadConf._

class BotConfig {
  def nick: String = {
    loadConfig.get("nick").toString
  }

  def loginName: String = {
    loadConfig.get("login").toString
  }

  def realname: String = {
    loadConfig.get("realname").toString
  }

  def server: String = {
    loadConfig.get("server").toString
  }

  def port: Int = {
    loadConfig.get("port").toString.toInt
  }

  def channel: String = {
    loadConfig.get("channel").toString
  }

  def usessl: Boolean = {
    loadConfig.get("usessl").toString.toBoolean
  }

  def password: Option[String] = {
    catching(classOf[NullPointerException]) opt
      loadConfig.get("password").toString
  }

  def loadConfig: Properties = {
    val prop = new LoadConfig
    prop.loadConf
  }
}
