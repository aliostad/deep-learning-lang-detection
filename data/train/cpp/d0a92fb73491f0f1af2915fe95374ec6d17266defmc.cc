#include "arch/v4.h"

#define dprintln(a...) do { if (debug_mode&DEBUG_MARSHAL) println(a); } while (0)

ChunkID CMSConnection4::getMapChunk(int channels, int size, const char *name)

{
  int thisChunk = ++chunkID;

  dprintln("getFMC channels=%d size=%d name=%s -> chunkID %d", channels, size, name, thisChunk);
  assert(size==1);

  for (int i=0;i<numChannels;i++)
    if (channels&(1<<i))
      fpages[i]->add(new CMSChunk4(thisChunk, size, name, new CBEOpaqueType("idl4_fpage_t", globals.word_size*2, globals.word_size), new CBEOpaqueType("idl4_fpage_t", globals.word_size*2, globals.word_size), channels, 1, CHUNK_XFER_COPY));
  
  return thisChunk;  
}

CASTStatement *CMSConnection4::assignFMCFpageToBuffer(int channel, ChunkID chunkID, CASTExpression *rvalue)

{
  CMSChunk4 *chunk;

  chunk = findChunk(fpages[channel], chunkID);
  if (chunk)
    return chunk->type->buildAssignment(
      new CASTBinaryOp(".",
        buildSourceBufferRvalue(channel),
        new CASTIdentifier(chunk->name)),
      rvalue
    );
    
  panic("Cannot assign FMC fpage to buffer (chunk %d in channel %d)", chunkID, channel);
  return NULL;
}

CASTStatement *CMSConnection4::assignFMCFpageFromBuffer(int channel, ChunkID chunkID, CASTExpression *rvalue)

{
  CMSChunk4 *chunk;

  chunk = findChunk(fpages[channel], chunkID);
  if (chunk)
    return chunk->type->buildAssignment(
      rvalue,
      new CASTBinaryOp(".",
        buildTargetBufferRvalue(channel),
        new CASTIdentifier(chunk->name))
    );
    
  panic("Cannot assign FMC fpage from buffer (chunk %d in channel %d)", chunkID, channel);
  return NULL;
}

CASTExpression *CMSConnection4::buildFMCFpageTargetExpr(int channel, ChunkID chunkID)

{
  CMSChunk4 *chunk;

  chunk = findChunk(fpages[channel], chunkID);
  if (chunk)
    {
      return new CASTBinaryOp(".",
        buildTargetBufferRvalue(channel),
        new CASTIdentifier(chunk->name)
      );    
    }

  panic("Cannot build FMC fpage target expression (chunk %d in channel %d)", chunkID, channel);
  return NULL;
}

CASTExpression *CMSConnection4::buildFMCFpageSourceExpr(int channel, ChunkID chunkID)

{
  CMSChunk4 *chunk;

  chunk = findChunk(fpages[channel], chunkID);
  if (chunk)
    {
      return new CASTBinaryOp(".",
        buildSourceBufferRvalue(channel),
        new CASTIdentifier(chunk->name)
      );    
    }

  panic("Cannot build FMC fpage target expression (chunk %d in channel %d)", chunkID, channel);
  return NULL;
}
