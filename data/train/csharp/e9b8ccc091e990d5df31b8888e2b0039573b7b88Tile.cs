using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace McMapper
{
    public class Tile
    {
        Dictionary<int, Dictionary<int, Chunk>> _chunks;
        int _x;
        int _z;
        DateTime _lastUpdated;

        public Tile(int x, int z)
        {
            _x = x;
            _z = z;
            _chunks = new Dictionary<int, Dictionary<int, Chunk>>();
            _lastUpdated = DateTime.MinValue;
        }

        public void AddChunk(Chunk chunk)
        {
            if (!_chunks.ContainsKey(chunk.X))
                _chunks.Add(chunk.X, new Dictionary<int, Chunk>());
            
            if (!_chunks[chunk.X].ContainsKey(chunk.Z))
                _chunks[chunk.X].Add(chunk.Z, chunk);
            else
                _chunks[chunk.X][chunk.Z] = chunk;

            if (_lastUpdated < chunk.LastUpdated)
                _lastUpdated = chunk.LastUpdated;
        }

        public int X
        {
            get { return _x; }
        }

        public int Z
        {
            get { return _z; }
        }
    }
}
