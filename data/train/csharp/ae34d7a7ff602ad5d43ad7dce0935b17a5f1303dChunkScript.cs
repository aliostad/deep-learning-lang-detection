using UnityEngine;
using System;

namespace Assets.Script.Water
{
    public class ChunkScript : MonoBehaviour
    {
        public Chunk Chunk { get; private set; }
        public World World { get { return Chunk.World; } }

        public void Init(Chunk chunk)
        {
            if (Chunk != null)
            {
                throw new Exception("Chunk already initialized!");
            }
            else
            {
                Chunk = chunk;
            }
        }

        public Vector2 GetHitPosition(int triangleIndex)
        {
            return Chunk.GetHitPosition(triangleIndex);
        }
    }
}
