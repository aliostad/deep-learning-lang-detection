package com.github.chengpohi.config

import java.util.Base64

import com.github.chengpohi.model.User
import com.typesafe.config.ConfigFactory

import scala.collection.JavaConverters._

/**
  * fc
  * Created by chengpohi on 8/14/16.
  */
object Config {
  private[this] val loadConfig = ConfigFactory.load("users.conf")
  lazy val users = loadConfig.getConfig("crawler").getObjectList("users").asScala
    .map(c => User(c.toConfig.getString("mail"), decode(c.toConfig.getString("pass"))))
  val MAX_LOAD_TIME: Int = loadConfig.getConfig("crawler").getInt("load.time")
  val MAX_SCRIPT_TIME: Int = loadConfig.getConfig("crawler").getInt("script.time")
  def decode(s: String): String = new String(Base64.getDecoder.decode(s))
}
