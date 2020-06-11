using System;
using System.Collections.Generic;
using NLog;
using Silentor.TB.Client.Maps;
using Silentor.TB.Client.Network;
using Silentor.TB.Client.Players;
using Silentor.TB.Client.Storage;
using Silentor.TB.Client.Tools;
using Silentor.TB.Common.Maps;
using Silentor.TB.Common.Maps.Chunks;
using Silentor.TB.Common.Maps.Geometry;
using Silentor.TB.Common.Network.Messages;

namespace Silentor.TB.Client.Maps
{
    /// <summary>
    /// Loads all missing chunks in coordinates increasing order when player moves
    /// </summary>
    public class SimpleMapLoader : IMapLoader
    {
        private readonly IMapEditor _map;
        private readonly IServer _server;
        private readonly IChunkFactory _chunkFactory;
        private readonly IPlayer _player;
        private readonly IChunkStorage _chunkStorage;

        private Vector2i _oldPlayerChunkPosition;

        private static Logger Log = LogManager.GetLogger("Client.Map.SimpleMapLoader");

        public SimpleMapLoader(IMapEditor map, IServer server, IChunkFactory chunkFactory, IPlayer player, 
            IChunkStorage chunkStorage)
        {
            if (map == null) throw new ArgumentNullException("map");
            if (server == null) throw new ArgumentNullException("server");
            if (chunkFactory == null) throw new ArgumentNullException("chunkFactory");
            if (player == null) throw new ArgumentNullException("player");

            _map = map;
            _server = server;
            _server.ClientConnection.ChunkReceived += ClientConnectionOnChunkReceived;
            _chunkFactory = chunkFactory;
            _player = player;
            _chunkStorage = chunkStorage;
            _chunkStorage.Retrieved += ChunkStorageOnRetrieved;

            _player.Moved += OnPlayerMoved;

            _oldPlayerChunkPosition = Chunk.ToChunkPosition(_player.Position.ToMapPosition());

            foreach (var chunkPos in _map.Bounds)
                if (!_map.IsChunkPresent(chunkPos))
                    _server.ServerConnection.GetChunk(chunkPos);
        }

        private void OnPlayerMoved()
        {
            var newPlayerChunkPosition = Chunk.ToChunkPosition(_player.Position.ToMapPosition());

            //Update map if player moved enough
            if (newPlayerChunkPosition != _oldPlayerChunkPosition)
            {
                var offset = newPlayerChunkPosition - _oldPlayerChunkPosition;

                var removedChunks = new List<Chunk>();
                var addedChunkPlaces = new List<Vector2i>();

                _map.Resize(offset, removedChunks, addedChunkPlaces);

                foreach (var newChunkPos in addedChunkPlaces)
                {
                    var isChunkPresent = _chunkStorage.Retrieve(newChunkPos);
                    if (!isChunkPresent)
                        _server.ServerConnection.GetChunk(newChunkPos);
                }

                foreach (var oldChunks in removedChunks)
                    _chunkStorage.Store(oldChunks.ToChunkContents());

                _oldPlayerChunkPosition = newPlayerChunkPosition;
            }
        }

        private void ClientConnectionOnChunkReceived(ChunkContents chunkContents)
        {
            var newChunk = _chunkFactory.Create(chunkContents);
            _map.SetChunk(newChunk);

            Log.Trace("Set chunk {0} to map from server", newChunk);
        }

        private void ChunkStorageOnRetrieved(ChunkContents chunkContents)
        {
            var newChunk = _chunkFactory.Create(chunkContents);
            _map.SetChunk(newChunk);

            Log.Trace("Set chunk {0} to map from cache", newChunk);
        }
    }
}
