// Copyright(C) 2017 Amarok Games, Alexander Verbeek

using AmarokGames.Grids.Data;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using System;

namespace AmarokGames.Grids {

    public class Grid2D : MonoBehaviour {

        public enum GridType { Static = 0, Dynamic = 1 }

        public int GridId { get { return gridId; } }
        public int ChunkWidth { get { return chunkWidth; } }
        public int ChunkHeight { get { return chunkHeight; } }
        public GridType Type { get { return gridType; } }


        /// <summary>
        /// Contains a list of chunks that were created this frame.
        /// </summary>
        public IEnumerable<Int2> RecentlyCreated { get { return recentlyCreatedChunks; } }


        /// <summary>
        /// Contains a list of chunks that were removed this frame.
        /// </summary>
        public IEnumerable<Int2> RecentlyRemoved { get { return recentlyRemovedChunks; } }

        private List<Int2> recentlyCreatedChunks = new List<Int2>();
        private List<Int2> recentlyRemovedChunks = new List<Int2>();

        private int gridId;
        private int chunkWidth;
        private int chunkHeight;
        private GridType gridType;
        private LayerConfig layers;
        private Dictionary<Int2, Grid2DChunk> chunkObjects = new Dictionary<Int2, Grid2DChunk>();

        public Int2 GetGridCoord(Vector2 worldPos) {
            Vector2 localPos = transform.worldToLocalMatrix * worldPos;
            return new Int2(Mathf.FloorToInt(localPos.x), Mathf.FloorToInt(localPos.y));
        }

        [SerializeField]
        private bool drawChunkBoundsGizmo = false;
        [SerializeField]
        private bool drawChunkAABBGizmo = false;

        /// <summary>
        /// Create a new grid with the specified dimensions and layers. 
        /// Make sure to setup correctly setup the LayerConfig before creating any grids, since this cannot be changed after construction.
        /// </summary>
        public void Setup(int gridId, int chunkWidth, int chunkHeight, LayerConfig layers, GridType type) {
            this.gridId = gridId;
            this.chunkWidth = chunkWidth;
            this.chunkHeight = chunkHeight;
            this.layers = layers;
            this.gridType = type;

            // Set rigidbody settings according to gridType
            
            switch(gridType) {
                case GridType.Static:
                    // Static grids should not have rigidbodies. This would cause physics performance issues.
                    break;
                case GridType.Dynamic:
                    Rigidbody2D rigidbody = gameObject.AddComponent<Rigidbody2D>();
                    rigidbody.isKinematic = false;
                    rigidbody.simulated = true;
                    break;
            }
        }

        /// <summary>
        /// Creates a new empty chunk at the specified chunk coordinate.
        /// </summary>
        public ChunkData CreateChunk(Int2 chunkCoord) {

            if (chunkObjects.ContainsKey(chunkCoord)) {
                throw new System.Exception(string.Format("Chunk with offset {0} already exists in this grid.", chunkCoord));
            }

            // Create chunk data object
            ChunkData chunk = new ChunkData(chunkWidth * chunkHeight, layers);

            // Create and position chunk GameObject
            string name = string.Format("chunk {0}", chunkCoord);
            GameObject obj = new GameObject(name);
            obj.transform.SetParent(this.transform, false);
            Grid2DChunk chunkBehaviour = obj.AddComponent<Grid2DChunk>();
            Vector2 pos = new Vector2(chunkCoord.x * ChunkWidth, chunkCoord.y * ChunkHeight);
            chunkBehaviour.transform.localPosition = pos;
            chunkBehaviour.Setup(chunkCoord, this, chunk);
            chunkObjects.Add(chunkCoord, chunkBehaviour);

            recentlyCreatedChunks.Add(chunkCoord);
            return chunk;
        }

        #region indexing

        /// <summary>
        /// Returns the chunk coordinate associated with the specified grid coordinate. 
        /// The chunk coordinate and the grid coordinate are equal for the bottom-left cell in a chunk.
        /// </summary>
        public static Int2 GetChunkCoord(Int2 gridCoord, int chunkWidth, int chunkHeight) {
            int x = gridCoord.x / chunkWidth;
            int y = gridCoord.y / chunkHeight;

            // in case of negative numbers, we need to subtract by one chunk to get the correct value.
            // eg. for cell (-1,-1) we should get chunk (-64, -64) instead of chunk (0,0)
            // this could probably be optimized by removing the conditional.
            if (gridCoord.x < 0) x -= 1;
            if (gridCoord.y < 0) y -= 1;

            return new Int2(x, y);
        }

        /// <summary>
        /// Returns the grid coordinate associated with the specified chunk coordinate. 
        /// This grid coordinate corresponds to the bottom-left corner of the chunk.
        /// </summary>
        public static Int2 GetGridCoord(Int2 chunkCoord, int chunkWidth, int chunkHeight) {
            return new Int2(chunkCoord.x * chunkWidth, chunkCoord.y * chunkHeight);
        }

        /// <summary>
        /// Returns the index within a chunk buffer for this grid-local coordinate.
        /// </summary>
        public static int GetCellIndex(Int2 gridCoord, int chunkWidth, int chunkHeight) {
            Int2 localCoord = new Int2(Modulo(gridCoord.x, chunkWidth), Modulo(gridCoord.y, chunkHeight));
            return GetCellIndex(localCoord, chunkWidth);
        }

        private static int Modulo(int x, int n) {
            int y = x % n;
            if (y < 0) y = y + n;
            return y;
        }

        /// <summary>
        /// Returns the index within a chunk buffer for this chunk-local coordinate.
        /// </summary>
        public static int GetCellIndex(Int2 localCoord, int chunkWidth) {
            return localCoord.y * chunkWidth + localCoord.x;
        }

        /// <summary>
        /// Get grid coordinate of the cell in chunk local space.
        /// </summary>
        public static Int2 GetLocalGridCoordFromCellIndex(int index, int chunkWidth) {
            int x = index % chunkWidth;
            int y = index / chunkWidth;
            return new Int2(x, y);
        }

        /// <summary>
        /// Returns the axis aligned boundary containing all the currently loaded chunks in this grid.
        /// </summary>
        public Rect GetBounds2D() {
            Rect gridBounds = new Rect();
            foreach (Grid2DChunk chunk in chunkObjects.Values) {
                Rect chunkBounds = chunk.Bounds2D;
                gridBounds.xMin = Mathf.Min(gridBounds.xMin, chunkBounds.xMin);
                gridBounds.xMax = Mathf.Max(gridBounds.xMax, chunkBounds.xMax);
                gridBounds.yMin = Mathf.Min(gridBounds.yMin, chunkBounds.yMin);
                gridBounds.yMax = Mathf.Max(gridBounds.yMax, chunkBounds.yMax);
            }
            return gridBounds;
        }

        /// <summary>
        /// Get grid coordinate of the cell in grid space.
        /// </summary>
        public static Int2 GetGridCoordFromCellIndex(int index, Int2 chunkCoord, int chunkWidth, int chunkHeight) {
            Int2 localCoord = GetLocalGridCoordFromCellIndex(index, chunkWidth);
            Int2 chunkGridCoord = GetGridCoord(chunkCoord, chunkWidth, chunkHeight);
            return chunkGridCoord + localCoord;
        }

        #endregion

        #region data access

        public IEnumerable<Int2> GetAllChunks() {
            return chunkObjects.Keys;
        }

        public bool TryGetChunkData(Int2 chunkCoord, out ChunkData result) {
            Grid2DChunk chunk = null;
            if(chunkObjects.TryGetValue(chunkCoord, out chunk)) {
                result = chunk.Data;
                return true;
            } else {
                result = null;
                return false;
            }
        }

        public bool TryGetChunkObject(Int2 chunkCoord, out Grid2DChunk result) {
            return chunkObjects.TryGetValue(chunkCoord, out result);
        }

        public IDataBuffer TryGetBuffer(Int2 chunkCoord, LayerId layerId) {
            ChunkData chunk;
            if(TryGetChunkData(chunkCoord, out chunk)) {
                return chunk.GetBuffer(layerId);
            } else {
                return null;
            }
        }

        public IEnumerable<Int2> GetLoadedChunks() {
            return chunkObjects.Keys;
        }

        public static IEnumerable<Int2> GetChunks(Int2 minGridCoord, Int2 maxGridCoord, int chunkWidth, int chunkHeight) {
            // round down to chunk boundaries.
            Int2 minChunk = GetChunkCoord(minGridCoord, chunkWidth, chunkHeight);
            Int2 maxChunk = GetChunkCoord(maxGridCoord, chunkWidth, chunkHeight);

            List<Int2> result = new List<Int2>();
            for (int y = minChunk.y; y <= maxChunk.y; ++y) {
                for (int x = minChunk.x; x <= maxChunk.x; ++x) {
                    Int2 chunkCoord = new Int2(x, y);
                    result.Add(chunkCoord);
                }
            }
            return result;
        }

        ///// <summary>
        ///// Calculates Axis-Aligned Bounding Box in world space for the specified chunk.
        ///// </summary>
        //public Bounds CalculateChunkAABB(Int2 chunkCoord) {
        //    Vector3 pos = transform.position;
        //    Matrix4x4 m = transform.localToWorldMatrix;
        //    Vector2 p1 = m * new Vector2(chunkCoord.x * chunkWidth, chunkCoord.y * chunkHeight);
        //    Vector2 p2 = m * new Vector2(chunkCoord.x * chunkWidth, (chunkCoord.y + 1) * chunkHeight);
        //    Vector2 p3 = m * new Vector2((chunkCoord.x + 1) * chunkWidth, (chunkCoord.y + 1) * chunkHeight);
        //    Vector2 p4 = m * new Vector2((chunkCoord.x + 1) * chunkWidth, chunkCoord.y * chunkHeight);

        //    float[] x = { p1.x, p2.x, p3.x, p4.x };
        //    float[] y = { p1.y, p2.y, p3.y, p4.y };

        //    float minX = Mathf.Min(x);
        //    float minY = Mathf.Min(y);
        //    float maxX = Mathf.Max(x);
        //    float maxY = Mathf.Max(y);

        //    Vector3 size = new Vector3(maxX - minX, maxY - minY, 10);
        //    Vector3 center = new Vector3(minX + pos.x, minY + pos.y) + 0.5f * size;
        //    return new Bounds(center, size);
        //}

        public uint GetUnsignedInt(Int2 gridCoord, LayerId layerId) {
            Int2 chunkCoord = GetChunkCoord(gridCoord, chunkWidth, chunkHeight);
            ChunkData chunk;
            if (TryGetChunkData(chunkCoord, out chunk)) {
                int index = GetCellIndex(gridCoord, chunkWidth, chunkHeight);
                BufferUnsignedInt32 buffer = (BufferUnsignedInt32)chunk.GetBuffer(layerId);
                return buffer.GetValue(index);
            } else {
                return 0;
            }
        }

        public void SetCellValue<T>(Int2 gridCoord, LayerId layerId, T value) {
            Int2 chunkCoord = GetChunkCoord(gridCoord, chunkWidth, chunkHeight);
            ChunkData chunk;
            if (TryGetChunkData(chunkCoord, out chunk)) {
                int index = GetCellIndex(gridCoord, chunkWidth, chunkHeight);
                IDataBuffer buffer = chunk.GetBuffer(layerId);

                // set the new cell value
                buffer.SetValue(index, value);

                // mark the chunk and buffer as modified, so that other systems will be aware of the change.
                chunk.MarkModified(layerId.id, Time.frameCount);
            } else {
                // The chunk did not exist, don't set cell value.
            }
        }

        public object GetCellValue(Int2 gridCoord, LayerId layerId) {
            Int2 chunkCoord = GetChunkCoord(gridCoord, chunkWidth, chunkHeight);
            ChunkData chunk;
            if (TryGetChunkData(chunkCoord, out chunk)) {
                int index = GetCellIndex(gridCoord, chunkWidth, chunkHeight);
                IDataBuffer buffer = chunk.GetBuffer(layerId);
                return buffer.GetValue(index);
            } else {
                return 0;
            }
        }

        #endregion

        /// <summary>
        /// Clears the recently created and recently removed chunks lists.
        /// Call this near the end of a frame, after other systems have had a chance to respond to chunk changes. 
        /// (eg. at the end of Update or in LateUpdate)
        /// </summary>
        public void ClearRecent() {
            recentlyCreatedChunks.Clear();
            recentlyRemovedChunks.Clear();
        }

        // Get all chunks that are currently visible in the camera. This assumes a non-rotating orthographic camera.
        public IEnumerable<Int2> GetChunksWithinCameraBounds(Camera cam) {
            Rect bounds = cam.OrthoBounds2D();

            // Filter all chunks that intersect with camera bounds
            IEnumerable<Int2> result = chunkObjects.Values.Where(chunk => { return bounds.Overlaps(chunk.Bounds2D); }).Select(chunk => chunk.ChunkCoord);
            return result;
        }

        #region Gizmos

        void OnDrawGizmos() {
            DrawChunkGizmos();
        }

        private void DrawChunkGizmos() {
            IEnumerable<Int2> loadedChunks = GetLoadedChunks();
            foreach (Int2 chunkCoord in loadedChunks) {
                if(drawChunkBoundsGizmo)
                    DrawChunkBoundsGizmo(chunkCoord);
                if (drawChunkAABBGizmo)
                    DrawChunkAABBGizmo(chunkCoord);
            }
        }

        private void DrawChunkBoundsGizmo(Int2 chunkCoord) {
            Gizmos.matrix = transform.localToWorldMatrix;
            Gizmos.color = Color.white;
            Vector2 center = new Vector2(chunkCoord.x * chunkWidth + chunkWidth / 2, chunkCoord.y * chunkHeight + chunkHeight / 2);
            Vector2 size = new Vector2(chunkWidth, chunkHeight);
            Gizmos.DrawWireCube(center, size);
        }

        private void DrawChunkAABBGizmo(Int2 chunkCoord) {
            Grid2DChunk chunk;
            if(TryGetChunkObject(chunkCoord, out chunk)) {
                Gizmos.matrix = Matrix4x4.identity;
                Gizmos.color = Color.red;
                Rect bounds = chunk.Bounds2D;
                Gizmos.DrawWireCube(bounds.center, bounds.size);
            }

        }

        #endregion
    }
}
