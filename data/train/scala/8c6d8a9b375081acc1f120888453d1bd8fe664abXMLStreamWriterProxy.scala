/*
 * Copyright 2014 Frugal Mechanic (http://frugalmechanic.com)
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package fm.xml

import javax.xml.namespace.NamespaceContext
import javax.xml.stream.XMLStreamWriter

trait XMLStreamWriterProxy extends XMLStreamWriter {
  protected def self: XMLStreamWriter
  
  def close(): Unit = self.close()
  def flush(): Unit = self.flush()
  def getNamespaceContext(): NamespaceContext = self.getNamespaceContext()
  def getPrefix(uri: String): String = self.getPrefix(uri)
  def getProperty(name: String): Object = self.getProperty(name)
  def setDefaultNamespace(uri: String): Unit = self.setDefaultNamespace(uri)
  def setNamespaceContext(context: NamespaceContext): Unit = self.setNamespaceContext(context)
  def setPrefix(prefix: String, uri: String): Unit = self.setPrefix(prefix, uri)
  def writeAttribute(namespaceURI: String, localName: String, value: String): Unit = self.writeAttribute(namespaceURI, localName, value)
  def writeAttribute(prefix: String, namespaceURI: String, localName: String, value: String): Unit = self.writeAttribute(prefix, namespaceURI, localName, value)
  def writeAttribute(localName: String, value: String): Unit = self.writeAttribute(localName, value)
  def writeCData(data: String): Unit = self.writeCData(data)
  def writeCharacters(text: Array[Char], start: Int, length: Int): Unit = self.writeCharacters(text, start, length)
  def writeCharacters(text: String): Unit = self.writeCharacters(text)
  def writeComment(data: String): Unit = self.writeComment(data)
  def writeDTD(dtd: String): Unit = self.writeDTD(dtd)
  def writeDefaultNamespace(namespaceURI: String): Unit = self.writeDefaultNamespace(namespaceURI)
  def writeEmptyElement(localName: String): Unit = self.writeEmptyElement(localName)
  def writeEmptyElement(prefix: String, localName: String, namespaceURI: String): Unit = self.writeEmptyElement(prefix, localName, namespaceURI)
  def writeEmptyElement(namespaceURI: String, localName: String): Unit = self.writeEmptyElement(namespaceURI, localName)
  def writeEndDocument(): Unit = self.writeEndDocument()
  def writeEndElement(): Unit = self.writeEndElement()
  def writeEntityRef(name: String): Unit = self.writeEntityRef(name)
  def writeNamespace(prefix: String, namespaceURI: String): Unit = self.writeNamespace(prefix, namespaceURI)
  def writeProcessingInstruction(target: String, data: String): Unit = self.writeProcessingInstruction(target, data)
  def writeProcessingInstruction(target: String): Unit = self.writeProcessingInstruction(target)
  def writeStartDocument(encoding: String, version: String): Unit = self.writeStartDocument(encoding, version)
  def writeStartDocument(version: String): Unit = self.writeStartDocument(version)
  def writeStartDocument(): Unit = self.writeStartDocument()
  def writeStartElement(prefix: String, localName: String, namespaceURI: String): Unit = self.writeStartElement(prefix, localName, namespaceURI)
  def writeStartElement(namespaceURI: String, localName: String): Unit = self.writeStartElement(namespaceURI, localName)
  def writeStartElement(localName: String): Unit = self.writeStartElement(localName)
}