#include "chunkfactory.h"
#include "generic.h"
#include "meta.h"
#include "format.h"
#include "lgmk.h"

Chunk * 
ChunkFactory::decode(const Data& data, uint32_t *decoded, uint32_t offset)
{
	Chunk *chunk = 0;

	const uint8_t *bytes = data.bytes(offset);
	
	char id[5];
	memcpy(id, bytes, 4);
	id[4] = 0;
	
	if (memcmp(id, "META", 4) == 0)
	{
		chunk = new Meta();
	} else if(memcmp(id, "fmt ", 4) == 0)
	{
		chunk = new Format();
	} else if(memcmp(id, "LGMK", 4) == 0)
	{
		chunk = new Lgmk();
	}else
	{
		chunk = new Generic();
	}
	
	if (chunk == 0)
	{
		return 0;
	}

	(*decoded) += chunk->decode(data, offset);

	return chunk;
}

