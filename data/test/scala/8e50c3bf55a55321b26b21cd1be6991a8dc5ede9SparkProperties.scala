package vamp.ammonium

import java.io.{ File => JFile, Reader }
import java.net.URL
import java.util.Properties

import scala.collection.JavaConverters._

import better.files._

object SparkProperties {
  def load(filename: String): Unit = loadFile(filename)

  def loadFile(filename: String): Unit = loadFile(filename.toFile)
  def loadFile(file: JFile): Unit      = loadFile(file.toScala)
  def loadFile(file: File): Unit       = load(file.newFileReader.autoClosed)

  def loadURL(urlString: String): Unit = loadURL(new URL(urlString))
  def loadURL(url: URL): Unit          = load(url.openStream.reader.autoClosed)

  private def load(inReader: ManagedResource[Reader]): Unit =
    for {
      (k, v) <- getProperties(inReader)
      if k.startsWith("spark.")
    } sys.props.getOrElseUpdate(k, v)

  private def getProperties(inReader: ManagedResource[Reader]): Map[String, String] = {
    val properties = new Properties
    inReader.foreach(reader => properties.load(reader))
    properties.stringPropertyNames.asScala.map(k => (k, properties.getProperty(k).trim)).toMap
  }
}
