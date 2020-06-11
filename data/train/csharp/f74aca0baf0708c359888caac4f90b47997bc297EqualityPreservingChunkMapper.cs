using System.Collections.Generic;

namespace Diff.Generic.Algorithm
{
    /// <summary>
    /// Maps chunks to integers, preserving equality.
    /// </summary>
    public class EqualityPreservingChunkMapper<T>
    {
        private readonly IDictionary<T, int> hash;

        public EqualityPreservingChunkMapper()
        {
            hash = new Dictionary<T, int>();
        }

        public EqualityPreservingChunkMapper(IEqualityComparer<T> equalityComparer)
        {
            hash = new Dictionary<T, int>(equalityComparer);
        }

        public int GetHash(T chunk)
        {
            int chunkHash;
            if (!hash.TryGetValue(chunk, out chunkHash))
            {
                chunkHash = hash.Count;
                hash.Add(chunk, chunkHash);
            }
            return chunkHash;
        }
    }
}