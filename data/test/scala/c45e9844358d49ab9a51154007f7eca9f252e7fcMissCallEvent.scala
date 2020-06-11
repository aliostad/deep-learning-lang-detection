package com.asiainfo.ocdc.streaming

import org.apache.spark.rdd.RDD
import org.apache.spark.sql.{DataFrame, Row}

/**
 * Created by leo on 7/23/15.
 */
class MissCallEvent extends MCBSEvent {

  override def transformDF2RDD(old_dataframe: DataFrame, partitionKeyIdx: Int): RDD[Row] = {
    val numPartions = old_dataframe.rdd.partitions.length
    //    old_dataframe.map(row => (row.getString(partitionKeyIdx), row)).partitionBy(new HashPartitioner(numPartions)).map(_._2)
    old_dataframe.map(row => (row.getString(partitionKeyIdx), row)).groupByKey().flatMap(_._2)
  }

}
