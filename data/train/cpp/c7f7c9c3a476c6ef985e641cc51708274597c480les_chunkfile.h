#ifndef LES_CHUNKFILE_HH
#define LES_CHUNKFILE_HH

#include "les_base.h"

// Chunk File Format: overlaid onto a constant class

class LES_ChunkFile
{
public:
	const char* GetID(void) const;
	int GetNumChunks(void) const;
	const void* GetChunkData(const int chunk) const;

	friend class LES_DefinitionFile;

private:
	LES_ChunkFile();
	~LES_ChunkFile();
	void Settle(void);

	char m_ID[4];
	LES_uint32 m_numChunks;
	LES_int32 m_chunkOffsets[1];	// m_chunkOffsets[m_numChunks]
	// chunkData[0]
	// chunkData[1]
	// ....
	// chunkData[numChunks-1]]
};

inline const char* LES_ChunkFile::GetID(void) const
{
	return m_ID;
}

inline int LES_ChunkFile::GetNumChunks(void) const
{
	return m_numChunks;
}

inline const void* LES_ChunkFile::GetChunkData(const int chunk) const
{
	const int chunkOffset = m_chunkOffsets[chunk];
	const char* basePtr = m_ID;
	const char* chunkPtr = basePtr + chunkOffset;
	return chunkPtr;
}

#endif // #ifndef LES_CHUNKFILE_HH
