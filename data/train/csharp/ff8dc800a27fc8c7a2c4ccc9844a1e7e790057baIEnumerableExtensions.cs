using System.Collections.Generic;
using System.Linq;

namespace Psns.Common.SystemExtensions
{
    public static class IEnumerableExtensions
    {
        const int ChunkSize = 500;

        public static IEnumerable<IEnumerable<T>> Chunk<T>(this IEnumerable<T> items, int chunkSize = ChunkSize)
        {
            var chunks = new List<IEnumerable<T>>();

            int pageNumber = 1;
            var chunk = items.Take(chunkSize);

            do
            {
                chunks.Add(chunk);
                chunk = items.Skip(chunkSize * pageNumber++).Take(chunkSize);
            }
            while(chunk.Count() > 0);

            return chunks;
        }
    }
}