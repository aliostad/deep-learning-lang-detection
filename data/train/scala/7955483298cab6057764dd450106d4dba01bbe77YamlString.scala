package net.lshift.typesetr.cmd

import org.yaml.snakeyaml.Yaml
import scopt.Read

abstract class YamlString {
  def dump: String
  def toScalaMap: Map[String, AnyRef]
  def isValid: Boolean
}

object YamlString {
  def load(doc: String): YamlString = {
    val yaml = new Yaml()
    new YamlObj(yaml.load(doc))
  }

  class YamlObj(loadedDoc: AnyRef) extends YamlString {
    def dump: String = {
      val yaml = new Yaml()
      yaml.dump(loadedDoc)
    }

    // TODO: Use SortedMap
    def toScalaMap: Map[String, AnyRef] = ???

    def isValid: Boolean = ???
  }

  implicit def toLogLeveRead: Read[YamlString] = Read.reads { (v: String) =>
    YamlString.load(v)
  }

}
