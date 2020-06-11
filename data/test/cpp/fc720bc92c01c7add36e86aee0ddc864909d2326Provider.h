// "Provider.h"
//

#pragma once

#define _DEFINE_DEPRECATED_HASH_CLASSES 0
#include <hash_map>


// ----------------------------------------------------------------------------
//  DECLARATIONS
// ----------------------------------------------------------------------------

namespace update
{
	namespace world
	{
		namespace chunk
		{
			class Provider {
			private:
				std::hash_map<
					glm::ivec3,
					Chunk*,
					hashdef::hash_glm_ivec3
				> _chunkMap;

				Chunk* _nullChunk;
			public:
				Provider( Chunk* nullChunk );
				~Provider( void );

				void insertChunk( glm::ivec3 chunkPos, Chunk* chunk );

				Chunk* getChunk( glm::ivec3 chunkPos ) const;
			};
		}
	}
}