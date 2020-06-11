package org.nolat.castleforge.xml

import javax.xml.validation.SchemaFactory
import javax.xml.XMLConstants
import javax.xml.transform.stream.StreamSource
import java.io.File
import org.apache.commons.io.FileUtils
import java.io.InputStream;
import org.nolat.castleforge.Config

object SpriteLoad {

  def loadSprite(pathToFile: String): Animations = {
    loadSprite(new File(pathToFile))
  }

  def loadSprite(file: File): Animations = {
    loadSprite(file, Config.animationXsd)
  }

  def loadSprite(file: File, schema: InputStream): Animations = {
    val source = FileUtils.openInputStream(file)
    loadSprite(source, schema)
  }

  def loadSprite(stream: InputStream): Animations = {
    loadSprite(stream, Config.animationXsd)
  }

  def loadSprite(stream: InputStream, xsdStream: InputStream): Animations = {
    val factory = SchemaFactory.newInstance(XMLConstants.W3C_XML_SCHEMA_NS_URI)
    val schema = factory.newSchema(new StreamSource(xsdStream))
    val xml = new SchemaAwareFactoryAdapter(schema).load(stream)
    scalaxb.fromXML[Animations](xml)

  }
}