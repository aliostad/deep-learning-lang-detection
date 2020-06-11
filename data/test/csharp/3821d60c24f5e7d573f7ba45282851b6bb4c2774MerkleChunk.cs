using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;

namespace Veggerby.Algorithm.Trees.MerkleTree
{
    public class MerkleChunk<T> : MerkleHash<T>
    {
        private T _chunk;

        public T Chunk
        {
            get { return _chunk; }
            set { SetChunk(value); }
        }

        protected virtual void SetChunk(T chunk)
        {
            _chunk = chunk;
            SetInvalid();
        }

        public MerkleChunk(T chunk, byte[] hash = null) : base(hash)
        {
            SetChunk(chunk);
        }
    }
}