#include "StreamPacket.h"
#include <map>

#pragma once

template<class Handler>
class PacketHandlerMgr
{
public:
	typedef map<uint16, Handler> PacketHandlerMap;
	typedef typename PacketHandlerMap::iterator PacketHandlerMapIter;

protected:
	PacketHandlerMap		m_PacketHandlerMap;

public:
	PacketHandlerMgr(){}
	~PacketHandlerMgr(){}

	//×¢²áÏûÏ¢»Øµ÷;
	bool Register(uint16 commandId, Handler handler)
	{
		if (GetPacketHandler(commandId) != 0)
		{
			//Assert(false);
		}
		m_PacketHandlerMap[commandId] = handler;
		return true;
	}

	//get
	Handler GetPacketHandler(uint16 commandId)
	{
		PacketHandlerMapIter it = m_PacketHandlerMap.find(commandId);
		if (it != m_PacketHandlerMap.end())
		{
			return it->second;
		}
		return 0;
	}
};

//ÏûÏ¢»Øµ÷½Ó¿Ú;
typedef int (*PacketHandler)( Stream& stream);
class MsgHandler : public PacketHandlerMgr<PacketHandler>
{
public:
	MsgHandler(){};
	~MsgHandler(){};
	static MsgHandler& GetInstance()
	{
		static MsgHandler s_msgHandler;
		return s_msgHandler;
	}
};