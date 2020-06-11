#include "chunk.h"

#include "r3000a.h"

int readChunk(chunk &outChunk, unsigned char *chunkData)
{
  outChunk.data       = chunkData;
  outChunk.magic      = getHword(chunkData,      CHUNK_MAGIC, true);
  outChunk.type       = getHword(chunkData,       CHUNK_TYPE, true); 
  outChunk.CID        =  getWord(chunkData,        CHUNK_CID, true);
  outChunk.entryCount =  getWord(chunkData, CHUNK_ENTRYCOUNT, true);
  outChunk.checksum   =  getWord(chunkData,   CHUNK_CHECKSUM, true);

  if (outChunk.type == 0)
  {
    unsigned long prevOffset = 0;
	  for (int count = 0; count < outChunk.entryCount; count++)
    {
      unsigned long offset      = getWord(chunkData, CHUNK_ENTRYOFFSETS+(count*4), true);
      outChunk.entryData[count] = &chunkData[offset];
	
	    outChunk.entrySize[count] = offset - prevOffset;
	    readEntry(outChunk.entries[count], outChunk.entryData[count]);
	    prevOffset = offset;
    }
  }
  
  return outChunk.type;
}

int lookupEntryIndex(unsigned long EID, chunk *entryChunk)
{
  for (int count = 0; count < entryChunk->entryCount; count++)
  {
    if (entryChunk->entries[count].EID == EID)
	    return count;
  }
  
  return -1;
}

entry *lookupEntry(unsigned long EID, chunk *entryChunk)
{
  int entryIndex = lookupEntryIndex(EID, entryChunk);
  
  return &entryChunk->entries[entryIndex];
}