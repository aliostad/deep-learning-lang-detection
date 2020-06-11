using MinecraftClient.Enums;

namespace MinecraftClient.Data.Anvil
{
    public class Block
    {
        public int ID;
        public string Name;
        public int X;
        public int Y;
        public int Z;
        public int ChunkX;
        public int ChunkZ;

        public Block(int id, int x, int y, int z, int chunkX, int chunkZ)
        {
            ID = id;
            X = x;
            Y = y;
            Z = z;
            ChunkX = chunkX;
            ChunkZ = chunkZ;

            Name = ((Blocks)ID).ToString();
        }

    }
}
