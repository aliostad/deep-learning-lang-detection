package edu.berkeley.cs.amplab.carat.dynamodb

import edu.berkeley.cs.amplab.carat._
import com.amazonaws.services.dynamodb.model.DescribeTableRequest
import collection.JavaConversions._

/**
 * Program to dump DynamoDb tables.
 */
object DumpTables {
  def main(args: Array[String]) {
    val tables = DynamoDbEncoder.dd.listTables().getTableNames()
    dumpTables(tables: _*)
  }

  def dumpTables(tables: String*) {
    for (t <- tables) {
      println("Table: " + t)
      var (k,res) = DynamoDbDecoder.getAllItems(t)
      for (i <- res)
        println(i.mkString(", "))
      while(k != null){
        val (k2,res2) = DynamoDbDecoder.getAllItems(t, k)
        k = k2
        res = res2
        for (i <- res)
          println(i.mkString(", "))
      }
    }
  }
}
