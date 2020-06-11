package com.vijay.spark.scala.rnd

import org.apache.spark.SparkConf
import org.apache.spark.api.java.JavaSparkContext
import org.apache.spark.SparkContext

object RunLoadJSON {
  def main(args: Array[String]): Unit = {
    println("Running Load JSON...")

    val config = new SparkConf().setMaster("local").setAppName("LoadJSON")
    config.set("spark.serializer", "org.apache.spark.serializer.JavaSerializer")
    //val sc = new JavaSparkContext(config)
    //val sc= new SparkContext("local", "LoadJSON", System.getenv("SPARK_HOME"))
    val sc= new SparkContext(config)
    sc.setLogLevel("FATAL")

    val loadJSON = new LoadJSON(sc)with Serializable
   // loadJSON.personJson()
    loadJSON.loadCustomerJson()
  }
}