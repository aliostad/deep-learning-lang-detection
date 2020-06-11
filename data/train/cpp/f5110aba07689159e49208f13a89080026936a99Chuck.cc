/*
 * Chuck.cc
 *
 *  Created on: 18 avr. 2012
 *      Author: nagriar
 */

#include <core/fileManager/Chuck.hh>

Chunk::Chunk()
{
  subChunk_ = nullptr;
}

Chunk::Chunk(Chunk& copy)
{
  if (copy.subChunk_)
  {
    subChunk_ = reinterpret_cast<avifile::s_sub_chunk*>(malloc(sizeof(avifile::s_sub_chunk)));
    memcpy(subChunk_, copy.subChunk_, sizeof(avifile::s_sub_chunk));
    if (copy.subChunk_->data)
    {
      subChunk_->data = malloc(MOD2(copy.subChunk_->size));
      memcpy(subChunk_->data, copy.subChunk_->data, MOD2(copy.subChunk_->size));
    }
    else
      subChunk_->data = nullptr;
  }
  else
    subChunk_ = nullptr;
}

Chunk::~Chunk()
{
  if (subChunk_)
  {
    if (subChunk_->data)
      free(subChunk_->data);
    free(subChunk_);
  }
}

void Chunk::clear()
{
  if (subChunk_)
    {
      if (subChunk_->data)
        free(subChunk_->data);
      subChunk_->data = nullptr;
      free(subChunk_);
      subChunk_ = nullptr;
    }
}



