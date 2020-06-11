using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace CarcassonneCraft
{
    public class Area
    {
        public int areaid { get; private set; }
        public string areaname { get; private set; }
        public int userid { get; private set; }
        public string username { get; private set; }
        public int rating { get; private set; }
        public bool rated { get; private set; }
        public List<UserInfo> editusers { get; private set; }

        Chunk[,] chunks = new Chunk[Env.XChunkN, Env.ZChunkN];

        public Area(AreaInfo info)
        {
            areaid = info.areaid;
            areaname = info.areaname;
            userid = info.userid;
            username = info.username;
            rating = info.rating;
            rated = info.rated;
            editusers = info.editusers;

            /*for (int x = 0; x < Env.XChunkN; x++)
            {
                for (int z = 0; z < Env.ZChunkN; z++)
                {
                    chunks[x, z] = new Chunk();
                }
            }*/
        }

        public void UpdateAreaInfo(AreaInfo info)
        {
            areaid = info.areaid;
            areaname = info.areaname;
            userid = info.userid;
            username = info.username;
            rating = info.rating;
            rated = info.rated;
            editusers = info.editusers;
        }

        public bool IsChunkLoaded(XZNum loadChunkPos)
        {
            XZNum loadChunkNum = Env.GetChunkNum(loadChunkPos);
            return chunks[loadChunkNum.xnum, loadChunkNum.znum] != null;
        }

        public void LoadDefaultChunk(XZNum loadChunkPos)
        {
            XZNum loadChunkNum = Env.GetChunkNum(loadChunkPos);
            chunks[loadChunkNum.xnum, loadChunkNum.znum] = new Chunk();
            //chunks[loadChunkNum.xnum, loadChunkNum.znum].CreatePrefab(loadChunkPos);
        }

        public void LoadChunk(Chunk chunk)
        {
            if(chunks[chunk.xchunknum, chunk.zchunknum] == null)
            {
                chunks[chunk.xchunknum, chunk.zchunknum] = new Chunk();
                chunks[chunk.xchunknum, chunk.zchunknum].diffs.AddRange(chunk.diffs);
            }
            else
            {
                chunks[chunk.xchunknum, chunk.zchunknum].diffs.Clear();
                chunks[chunk.xchunknum, chunk.zchunknum].diffs.AddRange(chunk.diffs);
            }            
        }

        public bool IsPrefabLoaded(XZNum loadChunkPos)
        {
            XZNum loadChunkNum = Env.GetChunkNum(loadChunkPos);
            return chunks[loadChunkNum.xnum, loadChunkNum.znum].IsPrefabLoaded();
        }

        public void LoadPrefab(XZNum loadChunkPos)
        {
            XZNum loadChunkNum = Env.GetChunkNum(loadChunkPos);
            chunks[loadChunkNum.xnum, loadChunkNum.znum].CreatePrefab(loadChunkPos);
        }

        public void UnLoadPrefab(XZNum unloadChunkPos)
        {
            XZNum loadChunkNum = Env.GetChunkNum(unloadChunkPos);
            if (chunks[loadChunkNum.xnum, loadChunkNum.znum] != null)
            {
                chunks[loadChunkNum.xnum, loadChunkNum.znum].DestroyPrefab(/*unloadChunkPos*/);
            }
        }

        public void UnLoadAreaPrefab()
        {
            for (int x = 0; x < Env.XChunkN; x++)
            {
                for (int z = 0; z < Env.ZChunkN; z++)
                {
                    if(chunks[x,z] != null)
                    {
                        chunks[x, z].DestroyPrefab();
                    }
                }
            }
        }

        public void SetBlock(SetBlockInfo block)
        {
            if (chunks[block.xchunknum, block.zchunknum] != null)
            {
                chunks[block.xchunknum, block.zchunknum].SetBlock(block);
            }
        }

        public void ResetBlock(SetBlockInfo block)
        {
            if (chunks[block.xchunknum, block.zchunknum] != null)
            {
                chunks[block.xchunknum, block.zchunknum].ResetBlock(block);
            }
        }
    }
}
