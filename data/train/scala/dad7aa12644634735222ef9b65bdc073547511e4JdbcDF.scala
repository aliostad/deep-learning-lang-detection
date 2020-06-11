package com.asto.dmp.mgtevl.base

import org.apache.spark.sql.DataFrame

object JdbcDF {
  def load(dbtable: String): DataFrame = {
    Contexts.sqlContext.read.format("jdbc").options(Map(
      "url" -> Props.get("jdbc_conn"),
      "dbtable" -> dbtable,
      "driver" -> Props.get("jdbc_driver")
    )).load()
  }

  def load(dbtable: String, fields: String): DataFrame = {
    load(dbtable).select(fields)
  }

  def load(dbtable: String, fields: String, condition: String): DataFrame = {
    load(dbtable, fields).filter(condition)
  }
}
