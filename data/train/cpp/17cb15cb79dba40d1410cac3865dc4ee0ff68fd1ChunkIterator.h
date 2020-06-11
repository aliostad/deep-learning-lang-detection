#ifndef EET_CHUNK_ITERATOR_H
#define EET_CHUNK_ITERATOR_H

/* EFLxx includes */
#include "Chunk.h"

namespace Eetxx {

/* forward declarations */
class Document;

class ChunkIterator :
      public std::iterator<std::forward_iterator_tag, char *, void>
{
public:
  ChunkIterator (char **chunk, Document &doc);

  Chunk operator * () const throw ();

  bool operator == (const ChunkIterator &i);

  bool operator != (const ChunkIterator &i);

  ChunkIterator &operator ++ () throw ();

  ChunkIterator operator ++ (int) throw ();

private:
  ChunkIterator ();
  char     **the_chunk;
  Document  &_doc;
};

} // end namespace Eetxx

#endif // EET_CHUNK_ITERATOR_H
