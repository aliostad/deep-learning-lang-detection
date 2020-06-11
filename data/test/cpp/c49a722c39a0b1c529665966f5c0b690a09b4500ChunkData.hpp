//--------------------------------------------------------------------------------
//
// ShortHike
//
// Copyright 2002-2005 Kai Backman, Mistaril Ltd.
//
//--------------------------------------------------------------------------------

#pragma once
#ifndef FILE_CHUNK_DATA_HPP
#define FILE_CHUNK_DATA_HPP

class ChunkData;

class ChunkIterator
{
  friend class ChunkStream;
public:
  ChunkIterator(int8u* data = NULL, size_t fileSize = 0, size_t filePos = 0);
  size_t getChunkSize();
  string getChunkType();
  unsigned long getCRC();
  
  ChunkIterator& operator++();
  bool operator==(const ChunkIterator& rhs);
  bool operator!=(const ChunkIterator& rhs);

  bool isValid();
  bool checkCRC();

//   bool seek(size_t chunkPos)
//   {
//     if(chunkPos < 0 || chunkPos > mChunkReadPos) return false;
//     mChunkReadPos = chunkPos;
//   }

//   size_t tell()
//   {
//     return mChunkReadPos;
//   }

//   bool eof()
//   {
//     return mChunkReadPos >= mChunkSize;
//   }

  size_t read(void* buffer, size_t bytes);
  bool readCompressed(void* buffer, size_t bytes);
  bool readString(string &oString);  

  template <class C> bool read(C& oValue)
  {
    size_t bytesToRead = sizeof(C);
    return read(&oValue, bytesToRead) == bytesToRead;
  }

private:
  int8u* getReadPosition();  
  void readChunkSize();

  int8u* mData;
  size_t mSize;

  size_t mChunkPos;
  size_t mChunkSize;  
  size_t mChunkReadPos;
};

class ChunkData
{
  friend class ChunkIterator;
  friend class CacheManager;
public:
  ChunkData(void* memory, size_t size);
  ~ChunkData();
  
  bool isSignatureValid() const;
  bool checkAll();
  
  ChunkIterator begin() {return ChunkIterator(mData, mSize, 8);}
  const ChunkIterator& end() {return mEndIterator;}
private:
  string mFileName;

  int8u* mData;
  size_t mSize;
  
  ChunkIterator mEndIterator;
};


#endif
