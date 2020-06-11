/*
 *
 *
 *
 */

#include "XMPPStream.hpp"


XMPPStream::XMPPStream(LightSocket *socket) {
	this->socket = socket;
}

void XMPPStream::setMessageHandler(XMPPMessageHandler* handler) {
	this->messageHandler = handler;
}

void XMPPStream::openStream() {
	SocketOutputStream *outputStream = this->socket->getOutputStream();
	string stream = "<?xml version='1.0'?>";
	stream += "<stream:stream";
    stream += "    from='juliet@im.example.com'";
    stream += "    to='im.example.com'";
    stream += "    version='1.0'";
    stream += "    xml:lang='en'";
    stream += "    xmlns='jabber:client'";
    stream += "    xmlns:stream='http://etherx.jabber.org/streams'>";
	const char * c = stream.c_str();
	outputStream->write(c, 0, stream.length());
}