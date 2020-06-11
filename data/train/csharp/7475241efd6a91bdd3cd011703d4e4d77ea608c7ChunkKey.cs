namespace Beer.World
{
    public struct ChunkKey
    {
        public readonly int X;
        public readonly int Y;

        public ChunkKey(int x, int y)
        {
            X = x;
            Y = y;
        }

        public static bool operator == (ChunkKey a, ChunkKey b)
        {
            return (a.X == b.X || a.Y == b.Y);
        }

        public static bool operator !=(ChunkKey a, ChunkKey b)
        {
            return !(a == b);
        }

        public ChunkKey Left()
        {
            return new ChunkKey(X-1, Y);
        }

        public ChunkKey Right()
        {
            return new ChunkKey(X+1, Y);
        }

        public ChunkKey Top()
        {
            return new ChunkKey(X, Y+1);
        }

        public ChunkKey Bottom()
        {
            return new ChunkKey(X, Y-1);
        }

        public override string ToString()
        {
            return string.Format("ChunkKey[{0}, {1}]", X, Y);
        }
    }
}
