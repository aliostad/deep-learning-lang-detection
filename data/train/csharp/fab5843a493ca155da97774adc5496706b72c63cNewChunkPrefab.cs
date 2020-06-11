using System;
using System.Collections;
using System.Collections.Generic;
using Assets.Code.GenerationEngine;
using Assets.Code.World.Chunks;
using UnityEngine;

namespace Assets.Code.Tasker
{
    class NewChunkPrefab : Task
    {
        private KeyValuePair<Position, ChunkData> _chunk;
        private readonly Action<Position, Chunk> _createNewChunkCallback;

        public NewChunkPrefab(KeyValuePair<Position, ChunkData> chunk, Action<Position, Chunk> createNewChunkCallback)
        {
            _chunk = chunk;
            _createNewChunkCallback = createNewChunkCallback;
        }

        public override IEnumerator Execute(Action taskdone)
        {
            yield return null;

            GameObject newChunkObject = PoolManager.Spawn(World.World.Instance.ChunkPrefab);

            yield return null;

            newChunkObject.transform.position = _chunk.Key.ToVector3();

            Chunk newChunk = newChunkObject.GetComponent<Chunk>();

            newChunk.Position = _chunk.Key;

            newChunk.SetChunkData(_chunk.Value);

            yield return null;

            Tasker.Instance.Add(new InitializeBlocks(newChunk, _chunk.Value));

            newChunk.DoRebuild();

            _createNewChunkCallback(_chunk.Key, newChunk);

            taskdone();

            yield break;
        }
    }
}
