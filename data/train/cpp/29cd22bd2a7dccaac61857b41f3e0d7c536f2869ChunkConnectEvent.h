#ifndef CHUNKCONNECTEVENT_H
#define CHUNKCONNECTEVENT_H

#include "ChunkEvent.h"

const int EVENTID_CHUNKCONNECT = 4;

class ChunkConnectEvent : public ChunkEvent
{
public:
	/*! What we can be our new relation to the chunk */
	enum ChunkConnection {
		ChunkConnection_Connect,
		ChunkConnection_Disconnect
	};

	ChunkConnectEvent(const ChunkPosition& position, ChunkConnection connectionType);

	inline virtual int id() {return EVENTID_CHUNKCONNECT;}

	virtual void perform(Server& server) const;
	virtual QByteArray serialize() const;

protected:
	ChunkConnection m_connectionType;
};

#endif // CHUNKCONNECTEVENT_H
