#include "io.h"

#include <cstring>

Io::Io()
	:	mNumOpenedSerialHandler	(0),
		mNumOpenedIicHandler	(0),
		mNumOpenedGpioHandler	(0),
		mNumOpenedWebsocketHandler	(0)
{
	
}

SerialHandler *Io::getSerialHandler(const char *portName)
{
	int i;
	for (i=0; i<mNumOpenedSerialHandler; ++i)
	{
		if (strcmp(portName, mOpenedSerialHandler[i]->getPortName()) == 0)
		{
			return mOpenedSerialHandler[i];
		}
	}
	mOpenedSerialHandler[mNumOpenedSerialHandler] = new SerialHandler(portName);
	mNumOpenedSerialHandler++;
	return mOpenedSerialHandler[mNumOpenedSerialHandler-1];
}

IicHandler *Io::getIicHandler(const char *portName)
{
	int i;
	for (i=0; i<mNumOpenedIicHandler; ++i)
	{
		if (strcmp(portName, mOpenedIicHandler[i]->getPortName()) == 0)
		{
			return mOpenedIicHandler[i];
		}
	}
	mOpenedIicHandler[mNumOpenedIicHandler] = new IicHandler(portName);
	++mNumOpenedIicHandler;
	return mOpenedIicHandler[mNumOpenedIicHandler-1];
}

GpioHandler *Io::getGpioHandler(const char *gpioKey)
{
	int i;
	for (i=0; i<mNumOpenedGpioHandler; ++i)
	{
		if (strcmp(gpioKey, mOpenedGpioHandler[i]->getGpioKey()) == 0)
		{
			return mOpenedGpioHandler[i];
		}
	}
	mOpenedGpioHandler[mNumOpenedGpioHandler] = new GpioHandler(gpioKey);
	++mNumOpenedGpioHandler;
	return mOpenedGpioHandler[mNumOpenedGpioHandler-1];
}

WsHandler *Io::getWebsocketHandler(const char *serverAddress, const int port)
{
	mOpenedWebsocketHandler[mNumOpenedWebsocketHandler] = new WsHandler(serverAddress, port);
	++mNumOpenedWebsocketHandler;
	return mOpenedWebsocketHandler[mNumOpenedWebsocketHandler-1];
}
