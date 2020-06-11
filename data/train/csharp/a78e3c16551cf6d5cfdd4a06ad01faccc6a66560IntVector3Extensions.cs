using System;

using Assets.Scripts.Framework.Utils.Vector;

using UnityEngine;

namespace Assets.Scripts.Framework.Utils.Extensions
{
    public static class IntVector3Extensions
    {
        public static IntVector3 GetChunkPosition(this IntVector3 position, int chunkSize)
        {
            var x = position.X > 0 ? Mathf.FloorToInt(position.X / chunkSize) * chunkSize : Mathf.FloorToInt(position.X % chunkSize) * chunkSize;
            var y = position.Y > 0 ? Mathf.FloorToInt(position.Y / chunkSize) * chunkSize : Mathf.FloorToInt(position.Y % chunkSize) * chunkSize;
            var z = position.Z > 0 ? Mathf.FloorToInt(position.Z / chunkSize) * chunkSize : Mathf.FloorToInt(position.Z % chunkSize) * chunkSize;

            return new IntVector3(x, y, z);
        }
    }
}
