
using Rimworld.model.entities.map;
namespace Rimworld.model.entities
{
    public class Map
    {
        private Chunk[,] chunks { get; set; }

        public Map()
        {
        }
        public Room GetOutsideRoom(Position position)
        {
            return GetChunkAt(position).outsideRoom;
        }

        public Chunk GetChunkAt(Position position)
        {
            return GetChunkAt(position.x, position.y);
        }
        public Chunk GetChunkAt(float x, float y)
        {
            float cx = (int)(x / GameConsts.CHUNK_SIZE);
            float cy = (int)(y / GameConsts.CHUNK_SIZE);
            if (x < 0) cx = chunkWidth - 1 - (x / GameConsts.CHUNK_SIZE);
            if (y < 0) cy = chunkHeight - 1 - (y / GameConsts.CHUNK_SIZE);
            if (cx >= chunkWidth) cx = cx - chunkWidth;
            if (cy >= chunkHeight) cy = cy - chunkHeight;
            return chunks[(int)cx, (int)cy];
        }


        int chunkWidth = 0;
        int chunkHeight = 0;
        internal void SetupWorld(int width, int height)
        {
            this.width = width;
            this.height = height;
            chunkWidth = width / GameConsts.CHUNK_SIZE;
            chunkHeight = height / GameConsts.CHUNK_SIZE;
            chunks = new Chunk[chunkWidth, chunkHeight];
            for (int i = 0; i < chunkWidth; i++)
            {
                for (int j = 0; j < chunkHeight; j++)
                {
                    chunks[i, j] = new Chunk(this, i, j);
                }
            }

        }


        public Tile GetTileAt(float x, float y)
        {
            Chunk chunk = GetChunkAt(x, y);

            int px = (int)(x % GameConsts.CHUNK_SIZE);
            int py = (int)(y % GameConsts.CHUNK_SIZE);
            return chunk.GetTileAt(px, py);
        }
        public Tile GetTileAt(Position position)
        {
            return GetTileAt(position.x, position.y);

        }

        public int height { get; private set; }

        public int width { get; private set; }
    }
}
