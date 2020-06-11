#ifndef INCLUDED_STREAMS_NESTED_STREAM_H_
#define INCLUDED_STREAMS_NESTED_STREAM_H_

#include "base/base.h"
#include "streams/stream.h"

template <typename T>
class NestedStream : public Stream<T> {
 public:
  typedef Stream<T> BaseStream;

  NestedStream(BaseStream& base_stream) : base_stream_(base_stream) {}

  virtual Type Get() {
    return base_stream_.Get();
  }

  virtual size_t GetN(Type* data, size_t count) {
    return 0;
  }

  virtual bool IsEOS() const {
    return base_stream_.IsEOS();
  }

  BaseStream* GetInnerStream() { return &base_stream_; }

 protected:
  BaseStream& base_stream_;

  DISALLOW_COPY_AND_ASSIGN(NestedStream);
};

#endif  // INCLUDED_STREAMS_NESTED_STREAM_H_
