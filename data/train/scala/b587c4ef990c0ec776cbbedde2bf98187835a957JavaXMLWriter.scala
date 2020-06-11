package net.technowizardry

import javax.xml.stream.XMLOutputFactory
import java.io.OutputStream

class JavaXMLWriter(outputStream : OutputStream) extends XMLWriter {
	var inner =  XMLOutputFactory.newFactory().createXMLStreamWriter(outputStream, "utf-8")
	def WriteStartDocument(encoding : String, version : String) = inner.writeStartDocument(encoding, version)
	def WriteStartElement(prefix : String, elemName : String, namespace : String) = inner.writeStartElement(prefix, elemName, namespace)
	def WriteStartElement(elemName : String, namespace : String) = {
		inner.writeStartElement(elemName)
		inner.writeDefaultNamespace(namespace)
	}
	def WriteAttribute(name : String, value : String, namespace : String) = inner.writeAttribute(namespace, name, value)
	def WriteNamespace(prefix : String, namespace : String) = inner.writeNamespace(prefix, namespace)
	def WriteDefaultNamespace(namespace : String) = inner.writeDefaultNamespace(namespace)
	def WriteText(text : String) = inner.writeCharacters(text)
	def WriteEndElement() = inner.writeEndElement()
	def Flush() = inner.flush
}