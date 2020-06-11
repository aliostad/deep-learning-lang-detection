#ifndef OBJ_MPOOL_HPP
#define OBJ_MPOOL_HPP

#include <iostream>
#include <cstring>

#include <obj/type.hpp>
#include <obj/util.hpp>

namespace obj
{
  class mPool : NonCopy
  {
  PRIVATE:
    struct Chunk
    {
      byte* block;
      byte* current;
      Chunk* next;

      Chunk (std::size_t size, Chunk* nextchunk_ = NULL)
        : block(new byte[size]), current(block), next(nextchunk_) {
      };
      
      ~Chunk () {
        delete[] block;
        if (next) delete next;
      }
      std::size_t used () const {
        return
          reinterpret_cast<std::size_t>(current) -
          reinterpret_cast<std::size_t>(block);
      }
    };
    
  PRIVATE:
    std::size_t size_;
    Chunk* chunk_;

  PRIVATE:
    std::size_t rest () const {
      return (size_ - chunk_->used());
    }
    
    void chunk_inc (Chunk* chunk, std::size_t size) {
      chunk->current =
        reinterpret_cast<byte*>
          (reinterpret_cast<std::size_t>(chunk->current) + size);
    }
    
  PUBLIC:
    enum { DEFAULT_SIZE = 4092 };
    
    mPool (std::size_t size = DEFAULT_SIZE) :
      size_(size), chunk_(new Chunk(size)) {};
    ~mPool () { delete(chunk_); }
    
  PUBLIC:
    void clear () {
      delete(chunk_);
      chunk_ = new Chunk(size_);
    }
    
    pointer allocate (std::size_t size) {
      if (size <= rest()) {
      alloc:
        pointer p = chunk_->current;
        chunk_inc(chunk_, size);
        return p;
      } else if (size <= size_) {
        Chunk* chunk = new Chunk(size_, chunk_);
        chunk_ = chunk;
        goto alloc;
      } else {
        Chunk* chunk = new Chunk(size, chunk_->next);
        chunk_inc(chunk, size);
        chunk_->next = chunk;
        return chunk->current;
      }
    }

    pointer copy (const pointer src, std::size_t len) {
      return memcpy(allocate(len), src, len);
    }

    char* copy (const char* src) {
      return
        static_cast<char*>(copy((pointer)src, std::strlen(src) + 1));
    }
    
    int length () const;
    std::size_t size () const;
  };
}

#endif
