#include "PlayerChunkEvent.h"

PlayerChunkEvent::PlayerChunkEvent(EventId eventId, QDataStream& stream)
	: BaseEvent(eventId, stream), ChunkEvent(eventId, stream), PlayerEvent(eventId, stream)
{
}

PlayerChunkEvent::PlayerChunkEvent(EventId eventId, quint32 worldId, const ChunkPosition& chunkPosition, quint32 playerId)
	: BaseEvent(eventId), ChunkEvent(eventId, worldId, chunkPosition), PlayerEvent(eventId, playerId)
{
}

PlayerChunkEvent::~PlayerChunkEvent()
{
}

void PlayerChunkEvent::serializeTo(QDataStream& stream) const
{
	BaseEvent::serializeTo(stream);
	ChunkEvent::serializeTo(stream);
	PlayerEvent::serializeTo(stream);
}

