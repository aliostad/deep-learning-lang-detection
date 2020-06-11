namespace generic.util.math
{
    using UnityEngine;
public class ChunkPos
{
        private Vector2 chunkPos;

        //constructors
        public ChunkPos(double x, double y)
        {
            chunkPos = new Vector2((float)x, (float)y);
        }
        public ChunkPos(GameObject source)
        {
            chunkPos = source.transform.position;
        }
        public ChunkPos(int x, int y)
        {
            chunkPos = new Vector2(x, y);
        }
        public ChunkPos(Vector3 source)
        {
            chunkPos = source;
        }

        //get methods
        public int getX()
        {
            return (int)chunkPos.x;
        }

        public int getY()
        {
            return (int)chunkPos.y;
        }
    }
}