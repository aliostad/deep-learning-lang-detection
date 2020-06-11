package org.gk.server.config

import com.typesafe.config.ConfigFactory

import scala.collection.mutable.Map

/**
 * Created by goku on 2015/7/22.
 */
object cfg {

  case class RepoInfo(url:String,port:Int)
  val config = ConfigFactory.load()

  def getPerProcessForBytes: Int = {
    config.getInt("PerProcessForBytes")
  }

  def getMavenPorxyManagePort: Int = {
    config.getInt("MavenPorxyManagePort")
  }


  def getLocalMainDir: String = {
    config.getString("LocalMainDir")
  }

  def getLocalRepoDir: String = {
    getLocalMainDir + "/cache"
  }


  def getMavenProxyServicePost:Int = {
    config.getInt("MavenPorxyServicePort")
  }
}




