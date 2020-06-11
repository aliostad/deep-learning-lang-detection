package com.zqh.spark.connectors.hive

import java.util.Properties

import com.zqh.spark.connectors.SparkWriter
import com.zqh.spark.connectors.config.ConnectorsWriteConf
import org.apache.spark.sql.{DataFrame}
/**
  * Created by zhengqh on 17/8/29.
  */
class WriteHive(conf: ConnectorsWriteConf) extends SparkWriter{

  override def write(df: DataFrame) = {
    val dbName = conf.getWriteConf("db")
    val tableName = conf.getWriteConf("table")
    val partition = conf.getWriteConf("partition", "")

    val writeMode = conf.getWriteConf("mode", "append")
    val dbTable = dbName + "." + tableName

    partition match {
      case _ if partition.equals("") =>
        df.write.mode(writeMode).saveAsTable(dbTable)
      case _ =>
        // TODO partition
        df.write.mode(writeMode).saveAsTable(dbTable)
    }
  }
}