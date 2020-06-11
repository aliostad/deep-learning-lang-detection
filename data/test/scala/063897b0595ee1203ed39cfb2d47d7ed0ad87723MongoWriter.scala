package com.zqh.spark.connectors.mongo

import com.zqh.spark.connectors.SparkWriter
import com.zqh.spark.connectors.config.ConnectorsWriteConf
import org.apache.spark.sql.{DataFrame}

/**
  * Created by zhengqh on 17/8/29.
  */
class MongoWriter(config: ConnectorsWriteConf) extends SparkWriter{

  override def write(df: DataFrame) = {
    val host = config.getWriteConf("host")
    val port = config.getWriteConf("port", "27017")
    val db = config.getWriteConf("db")
    val table = config.getWriteConf("table")
    val username = config.getWriteConf("user")
    val password = config.getWriteConf("password")
    val writeMode = config.getWriteConf("mode", "append")

    val uri = s"mongodb://$host:$port"

    val map = Map(
      "uri" -> uri,
      "database" -> db,
      "collection" -> table
    )

    df.write.options(map)
      .mode(writeMode)
      .format("com.mongodb.spark.sql")
      .save()
  }
}
