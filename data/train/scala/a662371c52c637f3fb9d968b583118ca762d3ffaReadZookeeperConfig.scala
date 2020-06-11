package it.jesinity.sparkate

import java.nio.file.Paths
import java.util
import scala.collection.JavaConverters._

import com.typesafe.config.{Config, ConfigFactory}

object ReadZookeeperConfig {

  val configuration: Config = ConfigFactory.load()

  def main(args: Array[String]): Unit = {

    val host: String = configuration.getString("zookeeper.host")
    val port: Int = configuration.getInt("zookeeper.port")

    println(s"parameters host = ${host} and port = ${port} ")

    val wikidataDump: String = configuration.getString("wikidata.dump")

    val stringList: List[String] = configuration.getStringList("samples").asScala.toList

    println(s"parameters wikidatadump = ${wikidataDump}  ")

  }

}
