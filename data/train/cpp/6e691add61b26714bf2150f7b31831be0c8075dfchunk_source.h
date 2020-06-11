/**************************************************************************//**
  \file chunk_source.h
  \brief ChunkSource: chunk as source
******************************************************************************/

#ifndef VALIB_CHUNK_SOURCE_H
#define VALIB_CHUNK_SOURCE_H

#include "../source.h"

/**************************************************************************//**
  \class ChunkSource
  \brief Represents single chunk as Source.
******************************************************************************/

class ChunkSource : public Source
{
public:
  ChunkSource()
  {}

  ChunkSource(Speakers spk_, const Chunk &chunk_)
  { init(spk_, chunk_); }

  bool init(Speakers spk_, const Chunk &chunk_)
  {
    spk = spk_;
    chunk = chunk_;
    sent = false;
    return true;
  }

  /////////////////////////////////////////////////////////
  // Source interface

  virtual void reset()
  { sent = false; }

  virtual bool get_chunk(Chunk &out)
  { 
    if (sent)
      return false;
    out = chunk;
    sent = true;
    return true;
  }

  virtual bool new_stream() const
  { return false; }

  virtual Speakers get_output() const
  { return spk; }

protected:
  Speakers spk;
  Chunk chunk;
  bool sent;
};

#endif
