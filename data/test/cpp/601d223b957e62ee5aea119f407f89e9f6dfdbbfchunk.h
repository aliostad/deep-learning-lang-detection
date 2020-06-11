#ifndef _ZEROCOPY_CHUNK_H_
#define _ZEROCOPY_CHUNK_H_

#include <memory>
#include <utility>

namespace zerocopy {

class base_chunk
{
public:
  typedef char byte_t;
  virtual std::pair<byte_t*, std::size_t> buff() = 0;
  virtual ~base_chunk() {}
};

class const_base_chunk
{
public:
  typedef char byte_t;
  virtual std::pair<const byte_t*, std::size_t> buff() = 0;
  virtual ~const_base_chunk() {}
};

typedef std::shared_ptr<base_chunk> base_chunk_ptr;
typedef std::shared_ptr<const_base_chunk> const_base_chunk_ptr;

}

#endif // _ZEROCOPY_CHUNK_H_
