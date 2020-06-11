#pragma once

class Packet;

class HandlerMap{
private:
	typedef void(*HandlerFunc)(Packet&);
	HandlerFunc HandlerTable[P_MAX];
	HandlerMap(){
		for (int i = 0; i < P_MAX; ++i)
			HandlerTable[i] = nullptr;
	}
	~HandlerMap() {}
public:
	static HandlerMap* GetInstance(){
		static HandlerMap pInstance;
		return &pInstance;
	}
	
	inline void RegistHandler(PACKET_HANDLER_TYPE eType, HandlerFunc func);
	inline void UnregistHandler(int type);
	inline bool HandlePacket(Packet& p);
};

class HandlerRegistHelper
{
	typedef void (*HandlerFunc)(Packet&);
public:
	HandlerRegistHelper(PACKET_HANDLER_TYPE eType, HandlerFunc func)
	{
		HandlerMap::GetInstance()->RegistHandler(eType, func);
	}
};

