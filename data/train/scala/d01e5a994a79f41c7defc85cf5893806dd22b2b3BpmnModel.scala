package de.choffmeister.bpmnmodel

import java.io.InputStream
import scala.xml._
import scalaxb._

object BpmnModel {
  def loadFromXml(xml: NodeSeq): TDefinitions = fromXML[TDefinitions](xml)
  def loadFromXmlString(xmlString: String): TDefinitions = loadFromXml(XML.loadString(xmlString))
  def loadFromXmlStream(xmlStream: InputStream): TDefinitions = loadFromXml(XML.load(xmlStream))
  def loadFromXmlResource(resourceName: String): TDefinitions = loadFromXmlStream(this.getClass.getResourceAsStream(resourceName))
}
