package io.hgis.dump

import io.hgis.ConfigurationFactory
import io.hgis.load._
import org.apache.hadoop.hbase.client.HTable

/**
 * Created by willtemperley@gmail.com on 19-Oct-15.
 */
object ExecuteDump {

  val configuredTables = Map[String, ExtractionBase] (

    "ee_protection" -> new DumpEcoregionProtection,
    "osm_grid" -> new DumpWayGrid,
    "pa_grid" -> new DumpSiteGrid,
    "sp_grid" -> new DumpSppGrid,
    "pa" -> new TestPA //FIXME just printing for debugging purposes currently

  )

  def main(args: Array[String]) {

    classOf[DumpEcoregionProtection].newInstance()

    if (args.length < 0) {
      println("Please provide a table")
      return
    }
    val (arg, others) = args.splitAt(1)

    val tableName = arg(0)
    val dumper = configuredTables.get(tableName).get.withArguments(others)

    val hTable = new HTable(ConfigurationFactory.get, tableName)

    dumper.executeExtract(hTable)

  }

}
