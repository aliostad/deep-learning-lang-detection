/**
  * Copyright 2013 MIT Libraries
  * Licensed under: http://www.apache.org/licenses/LICENSE-2.0
  */

package edu.mit.lib.resync

import java.io.OutputStream
import javax.xml.stream.{XMLOutputFactory, XMLStreamWriter}

import RSNamespace._
import Capability._

/**
 * Object to write (serialize) a ResourceMap to an XML document
 *
 * @author richardrodgers
 */
object XMLResourceMapWriter {
  
  /**
   * Writes a resource map as an XML document to a stream
   *
   * @param resMap the resource map
   * @param out the output stream
   */
  def write(resMap: ResourceMap, out: OutputStream) {
    val xsw = XMLOutputFactory.newInstance.createXMLStreamWriter(out, "utf-8")
    xsw.writeStartDocument("utf-8", "1.0")
    xsw.setDefaultNamespace(Sitemap.uri)
    xsw.setPrefix(ResourceSync.prefix, ResourceSync.uri)
    xsw.writeStartElement(resMap.mapName)
    xsw.writeNamespace(Sitemap.prefix, Sitemap.uri)
    xsw.writeNamespace(ResourceSync.prefix, ResourceSync.uri)
    resMap.links.foreach { link => writeLink(link, xsw) }
    xsw.writeEmptyElement(ResourceSync.uri, "md")
    xsw.writeAttribute("capability", resMap.capability.toString)
    val validityAttr = if (resMap.listLike) "at" else "from"
    val expiryAttr = if (resMap.listLike) "completed" else "until"
    if (resMap.validity.isDefined) xsw.writeAttribute(validityAttr, W3CDateTime.format(resMap.validity.get))
    if (resMap.expiry.isDefined) xsw.writeAttribute(expiryAttr, W3CDateTime.format(resMap.expiry.get))
    resMap.resources.foreach { res => writeResource(resMap.resourceName, res, xsw) }
    xsw.writeEndElement
    xsw.writeEndDocument
    xsw.close
  }

  private def writeLink(link: Link, writer: XMLStreamWriter) {
    writer.writeEmptyElement(ResourceSync.uri, "ln")
    writer.writeAttribute("href", link.href.toString)
    writer.writeAttribute("rel", link.rel)
    link.attrs.keySet.foreach { key =>
      writer.writeAttribute(key, link.attrs.get(key).get)
    }
  }

  private def writeResource(name: String, resource: Resource, writer: XMLStreamWriter) {
    writer.writeStartElement(name)
    writer.writeStartElement("loc")
    writer.writeCharacters(resource.location.toString)
    writer.writeEndElement
    if (resource.lastModified.isDefined) {
      writer.writeStartElement("lastmod")
      writer.writeCharacters(W3CDateTime.format(resource.lastModified.get))
      writer.writeEndElement
    }
    if (resource.changeFrequency.isDefined) {
      writer.writeStartElement("changefreq")
      writer.writeCharacters(resource.changeFrequency.get.toString)
      writer.writeEndElement
    }
    if (resource.priority.isDefined) {
      writer.writeStartElement("priority")
      writer.writeCharacters(resource.priority.get.toString)
      writer.writeEndElement
    }
    if (resource.metadata.isDefined) {
      writer.writeEmptyElement(ResourceSync.uri, "md")
      resource.metadata.get.keySet.foreach { key =>
        writer.writeAttribute(key, resource.metadata.get.get(key).get)
      }
    }
    resource.links.foreach { link => writeLink(link, writer)}
    writer.writeEndElement
  }
}
