package com.zqh.spark.connectors.jdbc

import java.util.Properties

import com.zqh.spark.connectors.SparkWriter
import com.zqh.spark.connectors.config.ConnectorsWriteConf
import org.apache.spark.sql.{DataFrame}

/**
  * Created by zhengqh on 17/8/29.
  */
@deprecated
class WriteJdbc(conf: ConnectorsWriteConf) extends SparkWriter{

  override def write(df: DataFrame) = {
    val url = conf.getWriteConf("url")
    val table = conf.getWriteConf("table")
    val username = conf.getWriteConf("user")
    val password = conf.getWriteConf("password")

    val properties = new Properties
    properties.put("user", username)
    properties.put("password", password)

    val writeMode = conf.getWriteConf("mode", "append")

    df.write.mode(writeMode).jdbc(url, table, properties)
  }
}