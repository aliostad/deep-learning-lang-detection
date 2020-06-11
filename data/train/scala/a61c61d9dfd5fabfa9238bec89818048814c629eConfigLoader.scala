package utils

/**
  * Created by zengxiaosen on 2017/5/17.
  */
import java.util.Properties

import com.typesafe.config.ConfigFactory
object ConfigLoader {
  def mysqlUser: String = ConfigFactory.load().getString("mysql.user")
  def redisHost = ConfigFactory.load().getString("redis.redisHost")
  def redisPort = ConfigFactory.load().getInt("redis.redisPort")
  def redisTimeout = ConfigFactory.load().getInt("redis.redisTimeout")
  def redisPassWord = ConfigFactory.load().getString("redis.redisPassWord")

  def mysqlPwd: String = ConfigFactory.load().getString("mysql.pwd")
  def batchInterval: Int = ConfigFactory.load().getInt("spark.batchinterval")

  def jdbcUrl: String = ConfigFactory.load().getString("mysql.jdbc")
  def writeGap: Int = ConfigFactory.load().getInt("app.writegap")
  def checkpoint: String = ConfigFactory.load().getString("dir.checkpoint")
  def topics: String = ConfigFactory.load().getString("kafka.topics")
  def brokers: String = ConfigFactory.load().getString("kafka.brokers")
  def outputDir: String = ConfigFactory.load().getString("dir.output")

  def mysqldb: String = ConfigFactory.load().getString("mysql.db")

  def appName: String = ConfigFactory.load().getString("app.name")

  def logtype: Int = ConfigFactory.load().getInt("log.logtype")

  def namespaceTable = ConfigFactory.load().getString("hbase.namespaceTable")

  def getMysqlProp: Properties = {
    val prop = new Properties()
    prop.put("user", mysqlUser)
    prop.put("password", mysqlPwd)
    prop
  }
}
