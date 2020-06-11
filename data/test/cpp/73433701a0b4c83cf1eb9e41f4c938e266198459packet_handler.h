/*************************************************************************
	> File Name: packet_handler.cpp
	> Author: cjj
	> Created Time: Thu 10 Apr 2014 09:36:30 AM CST
 ************************************************************************/
#ifndef PACKET_HANDLER_H
#define PACKET_HANDLER_H

#include <map>
#include "world_session.h"
namespace game_server
{
struct PacketHandler
{
	PacketHandler(void (WorldSession::*_handler)(base::WorldPacket&)) : handler(_handler){}
	PacketHandler() : handler(NULL){}
	void (WorldSession::*handler)(base::WorldPacket &);
};

class PacketHandlerMgr
{
public:
	static PacketHandlerMgr * GetInstance()
	{
		static PacketHandlerMgr _instance;
		return &_instance;
	}

	void AddHandler(int opCodes, void (WorldSession::*_handler)(base::WorldPacket &))
	{
		map_handler.insert(std::make_pair(opCodes, PacketHandler(_handler)));
	}

	PacketHandler  GetHandler(int opCode)
	{
		std::map<int, PacketHandler>::iterator iter = map_handler.find(opCode);
		if(iter != map_handler.end())
		{
			return iter->second;
		}
		else
		{
			return PacketHandler();
		}
	}
private:
	PacketHandlerMgr(){}
	std::map<int, PacketHandler> map_handler;
};
PacketHandlerMgr * g_handlerMgr = PacketHandlerMgr::GetInstance();

}

#endif
