using System;
using System.Collections.Generic;
namespace MTB
{
    public class ClientSceneManager
    {
        private Dictionary<WorldPos, ClientChangedChunk> _chunkMap;
        public ClientSceneManager()
        {
            _chunkMap = new Dictionary<WorldPos, ClientChangedChunk>(new WorldPosComparer());
        }

        //初始化玩家所持有的chunk信息
        public void AddPlayerInChunks(ClientPlayer player, WorldPos pos, int sign)
        {
            lock (_chunkMap)
            {

                ClientChangedChunk changedChunk;
                _chunkMap.TryGetValue(pos, out changedChunk);
                if (changedChunk == null)
                {
                    changedChunk = new ClientChangedChunk(pos);
                    changedChunk.ChangeSign(sign);
                    _chunkMap.Add(pos, changedChunk);
                }
                //				UnityEngine.Debug.Log("添加区块:" + pos.ToString() + " playerId:" + player.id);
                changedChunk.AddPlayer(player.id);
                player.AddChunkPos(pos);
            }
        }

        public void RemovePlayerChunks(ClientPlayer player, WorldPos pos)
        {
            lock (_chunkMap)
            {
                ClientChangedChunk changedChunk;
                _chunkMap.TryGetValue(pos, out changedChunk);
                if (changedChunk != null)
                {
                    changedChunk.RemovePlayer(player.id);
                    player.RemoveChunkPos(pos);
                    if (changedChunk.players.Count <= 0)
                    {
                        _chunkMap.Remove(pos);
                    }
                }
            }
        }

        public bool CanchangedChunkSaved(WorldPos pos)
        {
            lock (_chunkMap)
            {
                ClientChangedChunk changedChunk;
                _chunkMap.TryGetValue(pos, out changedChunk);
                if (changedChunk != null)
                {
                    return changedChunk.needSave;
                }
                return false;
            }
        }

		public void ChangeChunkNeedSaved(WorldPos pos,bool needSaved)
		{
			lock (_chunkMap)
			{
				ClientChangedChunk changedChunk;
				_chunkMap.TryGetValue(pos, out changedChunk);
				if (changedChunk != null)
				{
					changedChunk.ChangeNeedSave(needSaved);
				}
			}
		}

        public ClientChangedChunkData GetChangedChunkData(WorldPos pos)
        {
            lock (_chunkMap)
            {
                ClientChangedChunk changedChunk;
                _chunkMap.TryGetValue(pos, out changedChunk);
                if (changedChunk != null)
                {
                    return changedChunk.GetChangedData();
                }
                return null;
            }
        }

        public void ChangedSign(WorldPos pos, int sign)
        {
            lock (_chunkMap)
            {
                ClientChangedChunk changedChunk;
                _chunkMap.TryGetValue(pos, out changedChunk);
                if (changedChunk == null)
                {
                    //					changedChunk = new ClientChangedChunk();
                    //					_chunkMap.Add(pos,changedChunk);
                    //正常情况下不会出现为空的情况
                    throw new Exception("位置为Pos:" + pos.ToString() + "的chunk不存在，不能更改sign:" + sign);
                }
                changedChunk.ChangeSign(sign);
            }
        }

		public int GetSign(WorldPos pos)
		{
			lock (_chunkMap)
			{
				ClientChangedChunk changedChunk;
				_chunkMap.TryGetValue(pos, out changedChunk);
				if (changedChunk != null)
				{
					return changedChunk.GetSign();
				}
				return 0;
			}
		}

        public void ChangedBlock(WorldPos pos, ClientChangedBlock block)
        {
            lock (_chunkMap)
            {
                ClientChangedChunk changedChunk;
                _chunkMap.TryGetValue(pos, out changedChunk);
                if (changedChunk == null)
                {
                    //					changedChunk = new ClientChangedChunk();
                    //					_chunkMap.Add(pos,changedChunk);
                    throw new Exception("位置为Pos:" + pos.ToString() + "的chunk不存在，不能更改block:" + block.index);
                }
                changedChunk.ChangeBlock(block);
            }
        }

		public bool RefreshEntity(WorldPos chunkPos)
		{
			lock (_chunkMap)
			{
				ClientChangedChunk changedChunk;
				_chunkMap.TryGetValue(chunkPos, out changedChunk);
				if (changedChunk != null)
				{
					return changedChunk.RefreshEntity();
				}
				return false;
			}
		}

        public void ChangedArea(RefreshChunkArea area)
        {
            lock (_chunkMap)
            {
                for (int i = 0; i < area.chunkList.Count; i++)
                {
                    ClientChangedChunk changedChunk;
                    _chunkMap.TryGetValue(area.chunkList[i].chunk.worldPos, out changedChunk);
                    if (changedChunk != null)
                    {
                        for (int j = 0; j < area.chunkList[i].refreshList.Count; j++)
                        {
                            Int16 index = ClientChangedChunk.GetChunkIndex(area.chunkList[i].refreshList[j].Pos.x, area.chunkList[i].refreshList[j].Pos.y, area.chunkList[i].refreshList[j].Pos.z);
                            ClientChangedBlock block = new ClientChangedBlock(index, (byte)area.chunkList[i].refreshList[j].type, area.chunkList[i].refreshList[j].exid);
                            changedChunk.ChangeBlock(block);
                        }
                    }
                }
            }
        }


        public void BroadcastPlayerHasChunkPackage(ClientPlayer sourcePlayer, WorldPos chunkPos, NetPackage package, bool includeSelf)
        {
            lock (_chunkMap)
            {
                ClientChangedChunk changedChunk;
                _chunkMap.TryGetValue(chunkPos, out changedChunk);
                if (changedChunk != null)
                {
                    List<int> playerIds = changedChunk.players;
                    for (int i = 0; i < playerIds.Count; i++)
                    {
                        if (!includeSelf && playerIds[i] == sourcePlayer.id) continue;
                        ClientPlayer player = NetManager.Instance.server.playerManager.GetPlayer(playerIds[i]);
                        player.worker.SendPackage(package);
                    }

                }
            }
        }

        public void BroadcastPlaerAreaChangedPackage(ClientPlayer sourcePlayer, RefreshChunkArea area, NetPackage package, bool includeSelf)
        {
            lock (_chunkMap)
            {
                for (int i = 0; i < area.chunkList.Count; i++)
                {
                    ClientChangedChunk changedChunk;
                    _chunkMap.TryGetValue(area.chunkList[i].chunk.worldPos, out changedChunk);
                    if (changedChunk != null)
                    {
                        List<int> playerIds = changedChunk.players;
                        for (int j = 0; j < playerIds.Count; j++)
                        {
                            if (!includeSelf && playerIds[j] == sourcePlayer.id) continue;
                            ClientPlayer player = NetManager.Instance.server.playerManager.GetPlayer(playerIds[j]);
                            player.worker.SendPackage(package);
                        }
                    }
                }
            }
        }



        public void Dispose()
        {
            _chunkMap.Clear();
        }
    }
}

