#ifndef CHUNK_H
#define CHUNK_H

#include <QFutureWatcher>
#include <QList>
#include <QReadWriteLock>
#include <QPair>

#include "EventReadyObject.h"

class BlockInfo;
class ChunkDrawer;
class World;

const int CHUNK_X_SIZE = 20;
const int CHUNK_Y_SIZE = 256;
const int CHUNK_Z_SIZE = 20;
const int CHUNK_HEIGHT = CHUNK_Y_SIZE;

typedef QPair<int, int> ChunkPosition;

/*! A chunk of a World containing all BlockInfo */
class Chunk : public EventReadyObject
{
	Q_OBJECT
public:
	explicit Chunk(World* parentWorld, ChunkPosition position);
	~Chunk();

	/*! This returns the mutex of the Chunk. Be sure to unlock it when needed!! */
	inline QReadWriteLock& rwLock() {return m_rwLock;}

	virtual bool worldEvent(WorldEvent* worldEvent);
	virtual bool chunkEvent(ChunkEvent* chunkEvent);
	virtual bool blockEvent(BlockEvent* blockEvent);

	enum ChunkState {
		ChunkState_Active,
		ChunkState_Idle,
		ChunkState_Void
	};

	inline ChunkPosition position() const {return m_position;}
	int altitude(const int x, const int z);

	/*! Access a block from a chunk
  \warning The coordinates to pass are relative to the chunk, and thus must be inside!
 */
	BlockInfo* block(const int x, const int y, const int z);

	/*! Give the world the chunk belongs to */
	inline World& world() const {return *m_world;}

	/*! Convert coordinates relatives to the chunk into world coordinates */
	void mapToWorld(const int chunkX, const int chunkY, const int chunkZ, int& worldX, int& worldY, int& worldZ) const;

	/*! This will force the chunk to be redrawed */
	void makeDirty();

	void makeSurroundingChunksDirty() const;

	bool isCompressed() const;

	ChunkState state();

	void addPlayerWhoWantCompressedChunk(quint32 playerId);

signals:
	void activated();
	void compressed(); //!< Emitted when the chunk has been compressed
	void uncompressed();
	void dirtied();
	void idled();

public slots:
	void activate(); //!< Activate the chunk (it will be drawed)
	void activate(const QByteArray& data); //!< Activate thr chunk with compressed data
	void compress(); //!< Compress the chunk
	void onCompressed();
	void onUncompressed();
	void idle(); //!< Make the Chunk enter in an idle state (it will not be drawed)

private:
	World* m_world; //!< The world this chunk belongs to
	QReadWriteLock m_rwLock; //!< R/W mutex
	ChunkState m_state;
	bool b_dirty; //!< If we need to redraw the chunk

	QFuture<QByteArray> fba_compressedChunk; //!< The chunk, compressed if != NULL
	QFutureWatcher<void> fba_compressedChunkWatcher;
	QList<quint32> m_playersWantCompressedChunk; //!< A list of players who want to be informed when a chunk has been compressed

	QFuture<QByteArray> fba_uncompressedChunk;
	QFutureWatcher<void> fba_uncompressedChunkWatcher;

	ChunkPosition m_position; //!< The postion of the chunk in chunk unit.
	BlockInfo* p_BlockInfos; //!< A big array of all BlockInfo of the Chunk
};

#endif // CHUNK_H
