package org.s4s0l.shathel.deployer

import java.util

import org.yaml.snakeyaml.{DumperOptions, Yaml}

import scala.collection.JavaConverters._
/**
  * @author Marcin Wielgus
  */
trait OutputFormatter {
  def yaml: Yaml = {
    val options = new DumperOptions()
    options.setDefaultFlowStyle(DumperOptions.FlowStyle.BLOCK)
    new Yaml(options)
  }

  def response(map: Map[String, Any]): String = {
    yaml.dump(map.asJava).trim
  }

  def response(list: Seq[Any]): String = {
    yaml.dump(list.asJava).trim
  }



  def response(map: java.util.List[String]): String = {
    yaml.dump(map)
  }

  def ok(): String = {
    yaml.dump(Map("status" -> "ok").asJava).trim
  }
}
