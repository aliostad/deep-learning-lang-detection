namespace Vox.Utils
{
    public class Helpers
    {
        public static int GetChunkIndex1DFrom3D(int x, int y, int z) {
			int xx = x + Env.ChunkPadding;
			int yy = y + Env.ChunkPadding;
			int zz = z + Env.ChunkPadding;
			return xx + (zz << Env.ChunkPow) + (yy << Env.ChunkPow2);
        }

		public static void GetChunkIndex3DFrom1D(int index, out int x, out int y, out int z)
		{
			x = index & Env.ChunkMask;
			y = index >> Env.ChunkPow2;
			z = (index >> Env.ChunkPow) & Env.ChunkMask;

			x -= Env.ChunkPadding;
			y -= Env.ChunkPadding;
			z -= Env.ChunkPadding;
		}

        public static int MakeChunkCoordinate(int x) 
        {
            return ((x >= 0 ? x : x - Env.ChunkSize1) / Env.ChunkSize) * Env.ChunkSize;
        }
    }
}