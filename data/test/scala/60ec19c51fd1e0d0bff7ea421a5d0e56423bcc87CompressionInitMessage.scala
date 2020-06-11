package net.technowizardry.xmpp.messages

import net.technowizardry.XMLWriter
import net.technowizardry.xmpp.XmppNamespaces

class CompressionInitMessage(method : String) extends XmppProtocolMessage with WritableXmppMessage {
	def WriteMessage(writer : XMLWriter) {
		writer.WriteStartElement("compress", XmppNamespaces.Compression)
		writer.WriteStartElement("method", XmppNamespaces.Compression)
		writer.WriteText(method)
		writer.WriteEndElement()
		writer.WriteEndElement()
	}
}

class CompressedMessage extends XmppProtocolMessage {}

