using System;

namespace MCFire.Common.Coordinates
{
    public struct ChunkPositionDimension : IEquatable<ChunkPositionDimension>
    {
        readonly int _dimension;
        readonly int _chunkX;
        readonly int _chunkZ;

        public ChunkPositionDimension(int chunkX, int chunkZ, int dimension)
        {
            _dimension = dimension;
            _chunkX = chunkX;
            _chunkZ = chunkZ;
        }

        public ChunkPositionDimension(ChunkPosition position, int dimension)
        {
            _dimension = dimension;
            _chunkX = position.ChunkX;
            _chunkZ = position.ChunkZ;
        }

        public static implicit operator ChunkPosition(ChunkPositionDimension value)
        {
            return new ChunkPosition(value.ChunkX, value.ChunkZ);
        }

        public static bool operator ==(ChunkPositionDimension left, ChunkPositionDimension right)
        {
            return left.ChunkX == right.ChunkX && left.ChunkZ == right.ChunkZ && left.Dimension == right.Dimension;
        }

        public static bool operator !=(ChunkPositionDimension left, ChunkPositionDimension right)
        {
            return left.ChunkX != right.ChunkX || left.ChunkZ != right.ChunkZ || left.Dimension != right.Dimension;
        }

        public bool Equals(ChunkPositionDimension other)
        {
            return _chunkX == other._chunkX && _chunkZ == other._chunkZ && _dimension == other._dimension;
        }

        public override bool Equals(object obj)
        {
            if (ReferenceEquals(null, obj)) return false;
            return obj is ChunkPositionDimension && Equals((ChunkPositionDimension)obj);
        }

        public override int GetHashCode()
        {
            unchecked
            {
                int hashCode = _dimension;
                hashCode = (hashCode * 397) ^ _chunkX;
                hashCode = (hashCode * 397) ^ _chunkZ;
                return hashCode;
            }
        }

        public override string ToString()
        {
            return String.Format("{0}, {1}, Dimension: {2}", ChunkX, ChunkZ, Dimension);
        }

        public int Dimension
        {
            get { return _dimension; }
        }

        public int ChunkX
        {
            get { return _chunkX; }
        }

        public int ChunkZ
        {
            get { return _chunkZ; }
        }
    }
}