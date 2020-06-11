//--------------------------------------------------------------------------------
//
// ShortHike
//
// Copyright 2002-2005 Kai Backman, Mistaril Ltd.
//
//--------------------------------------------------------------------------------


#pragma once
#ifndef FILE_PERSISTENT_HPP
#define FILE_PERSISTENT_HPP

#include "ChunkCommon.hpp"

class ChunkIterator;
class ChunkStream;
class ChunkData;

class Persistent
{
public:
  virtual bool load(const ChunkIterator& begin, const ChunkIterator& end, ChunkIterator& curr) = 0;
  virtual bool save(ChunkStream* chunkStream) = 0;

  bool loadAll(ChunkData* chunkData);
};



#endif
