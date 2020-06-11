#include "qmongostream.h"

SOFT_BEGIN_NAMESPACE
MONGO_BEGIN_NAMESPACE

static void streamDeleter(mongoc_stream_t *ptr)
{
  mongoc_stream_destroy (ptr);
}

Stream :: Stream (QObject * parent)
   : QObject (parent)
{}

Stream :: Stream (mongoc_stream_t * stream, QObject * parent)
  : QObject (parent)
  , stream (stream, streamDeleter)
{}

Stream :: Stream (Stream const & other)
  : QObject (other.parent())
  , stream (other.stream)
{}

Stream :: Stream (Stream && other)
  : QObject (std::move (other.parent()))
  , stream (std::move (other.stream))
{
}

Stream :: ~Stream()
{}

MONGO_END_NAMESPACE
SOFT_END_NAMESPACE
