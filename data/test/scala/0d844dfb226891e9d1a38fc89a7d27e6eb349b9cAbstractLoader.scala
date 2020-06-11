package lesson2.loader

import org.apache.spark.sql.{DataFrame, SQLContext}

abstract class AbstractLoader(sql: SQLContext) extends Loader {

  def loadAirports: DataFrame = {
    loadAndRegister(airportsFile)
  }

  def loadCarriers: DataFrame = {
    loadAndRegister(carriersFile)
  }

  def loadFlights: DataFrame = {
    loadAndRegister(flightsFile)
  }

  private def loadAndRegister(file: String) = {
    val df = sql.read
      .format("com.databricks.spark.csv")
      .option("header", "true")
      .option("escape", "\\")
      .load(file)
    df.cache
    df.show
    df
  }

  def airportsFile: String
  def carriersFile: String
  def flightsFile: String
}