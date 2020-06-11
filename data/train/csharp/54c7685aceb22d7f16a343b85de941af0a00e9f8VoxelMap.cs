//
// VoxelMap.cs
//
// Author:
//       Evan Reidland <er@evanreidland.com>
//
// Copyright (c) 2014 Evan Reidland
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
using System;
using System.Collections.Generic;

namespace Spacebrick
{
    public class VoxelMapQuery
    {
        public VoxelMap Map { get; private set; }
        public VoxelChunk LastChunk { get; private set; }

        //Right now batch mode just turns off block changed notifications.
        //Very easy to break visuals this way.
        public bool InBatchMode { get; set; }

        private void GetNextChunk(int x, int y, int z, bool createIfMissing)
        {
            int chunkX = x;
            int chunkY = y;
            int chunkZ = z;

            bool shouldGet = false;
            VoxelChunk.ConvertWorldToChunk(ref chunkX, ref chunkY, ref chunkZ);

            if (LastChunk != null)
            {
                Vector3i lastChunkPosition = LastChunk.ChunkPosition;

                if (chunkX != lastChunkPosition.x || chunkY != lastChunkPosition.y || chunkZ != lastChunkPosition.z)
                    shouldGet = true;
            }
            else
                shouldGet = true;

            if (shouldGet)
            {
                if (createIfMissing)
                    LastChunk = Map.GetOrCreateChunk(chunkX, chunkY, chunkZ);
                else
                    LastChunk = Map.GetChunk(chunkX, chunkY, chunkZ);
            }
        }

        public Voxel GetVoxel(int x, int y, int z)
        {
            GetNextChunk(x, y, z, false);
            if (LastChunk != null)
            {
                VoxelChunk.ConvertWorldToLocal(ref x, ref y, ref z);
                return LastChunk.GetVoxel(x, y, z);
            }

            return new Voxel();
        }

        public void SetVoxelInExistingChunk(int x, int y, int z, Voxel voxel)
        {
            GetNextChunk(x, y, z, false);
            if (LastChunk != null)
            {
                VoxelChunk.ConvertWorldToLocal(ref x, ref y, ref z);
                LastChunk.SetVoxel(x, y, z, voxel, !InBatchMode);
            }
        }

        public void SetVoxel(int x, int y, int z, Voxel voxel)
        {
            GetNextChunk(x, y, z, true);
            if (LastChunk != null)
            {
                VoxelChunk.ConvertWorldToLocal(ref x, ref y, ref z);
                LastChunk.SetVoxel(x, y, z, voxel, !InBatchMode);
            }
        }
    }

    public class VoxelChunkCreatedEvent
    {
        public VoxelChunk Chunk { get; private set; }
        public VoxelChunkCreatedEvent(VoxelChunk chunk) { Chunk = chunk; }
    }
    public class VoxelMap
    {
        public const ulong OffsetToPositive = 1000000;
        public const ulong MaxSize = OffsetToPositive*2;

        private static Dictionary<ulong, VoxelChunk> _voxelMap = new Dictionary<ulong, VoxelChunk>();

        public EventHub Events { get; private set; }

        private EventCallbackList _chunkCreatedList;

        private static ulong ConvertChunkPositionToKey(int chunkX, int chunkY, int chunkZ)
        {
            ulong x = (ulong)chunkX + OffsetToPositive;
            ulong y = (ulong)chunkY + OffsetToPositive;
            ulong z = (ulong)chunkZ + OffsetToPositive;

            return z*MaxSize*MaxSize + y*MaxSize + x;
        }

        public VoxelChunk GetChunk(int chunkX, int chunkY, int chunkZ)
        {
            ulong key = ConvertChunkPositionToKey(chunkX, chunkY, chunkZ);
            VoxelChunk chunk;
            _voxelMap.TryGetValue(key, out chunk);
            return chunk;
        }

        public VoxelChunk GetChunkFromWorldPosition(int worldX, int worldY, int worldZ)
        {
            VoxelChunk.ConvertWorldToChunk(ref worldX, ref worldY, ref worldZ);
            return GetChunk(worldX, worldY, worldZ);
        }

        public VoxelChunk GetOrCreateChunkFromWorldPosition(int worldX, int worldY, int worldZ)
        {
            VoxelChunk.ConvertWorldToChunk(ref worldX, ref worldY, ref worldZ);
            return GetOrCreateChunk(worldX, worldY, worldZ);
        }

        public VoxelChunk GetOrCreateChunk(int chunkX, int chunkY, int chunkZ)
        {
            ulong key = ConvertChunkPositionToKey(chunkX, chunkY, chunkZ);
            VoxelChunk chunk;
            if (!_voxelMap.TryGetValue(key, out chunk))
            {
                chunk = new VoxelChunk(this, new Vector3i(chunkX, chunkY, chunkZ));
                _voxelMap[key] = chunk;
                _chunkCreatedList.Execute(new VoxelChunkCreatedEvent(chunk));
            }
            return chunk;
        }

        public Voxel ReadVoxel(int x, int y, int z)
        {
            int chunkX = x, chunkY = y, chunkZ = z;
            VoxelChunk.ConvertWorldToChunk(ref chunkX, ref chunkY, ref chunkZ);
            var chunk = GetChunk(chunkX, chunkY, chunkZ);
            if (chunk != null)
            {
                VoxelChunk.ConvertWorldToLocal(ref x, ref y, ref z);
                return chunk.GetVoxel(x, y, z);
            }

            return new Voxel();
        }

        public void ReadBlock(BlockQuery block, int x, int y, int z)
        {
            int chunkX = x, chunkY = y, chunkZ = z;
            VoxelChunk.ConvertWorldToChunk(ref chunkX, ref chunkY, ref chunkZ);
            var chunk = GetChunk(chunkX, chunkY, chunkZ);
            Voxel voxel;

            if (chunk != null)
            {
                VoxelChunk.ConvertWorldToLocal(ref x, ref y, ref z);
                voxel = chunk.GetVoxel(x, y, z);
            }
            else
                voxel = new Voxel();

            //TODO: Properly query for core voxel if current voxel.IsPointer
            block.Set(voxel, chunk, x, y, z);
        }

        public void SetVoxel(int x, int y, int z, Voxel voxel, bool notify = true)
        {
            //TODO: Writing blocks with different sizes/linking through a WriteBlock function
            var chunk = GetOrCreateChunkFromWorldPosition(x, y, z);
            VoxelChunk.ConvertWorldToLocal(ref x, ref y, ref z);
            chunk.SetVoxel(x, y, z, voxel, notify);
        }

        public VoxelMap(EventHub events)
        {
            Events = events;
            _chunkCreatedList = Events.GetList(typeof(VoxelChunkCreatedEvent));
        }
    }
}

