#pragma once
#include "Common.hpp"
#include "../FastList.hpp"

namespace Prelude
{
	template<typename Allocator> class ChunkList
	{
		struct Chunk
		{
			ListEntry<Chunk> entry;
		};
		
		private:
			FastList<Chunk> chunks;
			typename Allocator::Ref::Storage allocator;

		public:
			ChunkList(typename Allocator::Ref::Type allocator = Allocator::Ref::standard) : allocator(allocator) {}
			
			void *allocate(size_t bytes)
			{
				void *result = allocator.allocate(bytes + sizeof(Chunk));
				
				prelude_runtime_assert(result && "No memory was allocated.");
				
				Chunk *chunk = new (result) Chunk;
				
				chunks.append(chunk);
				
				return (void *)((uint8_t *)result + sizeof(Chunk));
			}
			
			~ChunkList()
			{
				typename FastList<Chunk>::Iterator chunk = chunks.begin();

				while(chunk != chunks.end())
				{
					Chunk *current = *chunk;
					++chunk;
					allocator.free(current);
				};
			}
	};
};
