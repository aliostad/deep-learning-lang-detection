#include "MPacketHandler.h"

namespace Mara
{
	MPacketHandler::MPacketHandler(MHandlerCallbackWrapper *pDefaultHandler) : _defaultHandler(pDefaultHandler) {}

	MPacketHandler::~MPacketHandler()
	{
		_handlers.clear();
	}

	void MPacketHandler::registerHandler(quint16 pType, MHandlerCallbackWrapper *pHandler)
	{
		_handlers.insert(pType, pHandler);
	}

	void MPacketHandler::handlePacket(MPacket *pPacket) const
	{
		if(_handlers.contains(pPacket->type()))
		{
			(*(_handlers.value(pPacket->type())))(pPacket);
		}
		else
		{
			(*_defaultHandler)(pPacket);
		}
	}
};
