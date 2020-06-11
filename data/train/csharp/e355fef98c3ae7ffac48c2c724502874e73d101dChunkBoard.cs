using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;
using System.Drawing;
using System.Collections;

namespace ClickWar2.Utility
{
    public class ChunkBoard<T>
        where T : new()
    {
        public ChunkBoard(int chunkSize = 8)
        {
            this.ChunkSize = chunkSize;
        }

        //#####################################################################################
        
        public readonly int ChunkSize;

        protected Dictionary<int, Dictionary<int, T[,]>> m_chunkMap = new Dictionary<int, Dictionary<int, T[,]>>();

        public int ChunkCount
        { get { return m_chunkMap.Count; } }

        //#####################################################################################

        public void Clear()
        {
            m_chunkMap.Clear();
        }

        //#####################################################################################

        public void GetChunkPosContainsItemAt(int itemX, int itemY, out int chunkX, out int chunkY)
        {
            if (itemX < 0)
            {
                chunkX = (itemX + 1) / ChunkSize;
                --chunkX;
            }
            else
            {
                chunkX = itemX / ChunkSize;
            }

            if (itemY < 0)
            {
                chunkY = (itemY + 1) / ChunkSize;
                --chunkY;
            }
            else
            {
                chunkY = itemY / ChunkSize;
            }
        }

        protected void ItemPosToLocalPos(int itemX, int itemY, out int localX, out int localY)
        {
            if (itemX < 0)
            {
                localX = (ChunkSize - 1) - (-(itemX + 1) % ChunkSize);
            }
            else
            {
                localX = itemX % ChunkSize;
            }

            if (itemY < 0)
            {
                localY = (ChunkSize - 1) - (-(itemY + 1) % ChunkSize);
            }
            else
            {
                localY = itemY % ChunkSize;
            }
        }

        //#####################################################################################

        public bool SetChunkAt(int chunkX, int chunkY, T[,] chunk)
        {
            if (m_chunkMap.ContainsKey(chunkX) == false)
                m_chunkMap.Add(chunkX, new Dictionary<int, T[,]>());

            if (m_chunkMap[chunkX].ContainsKey(chunkY) == false)
            {
                m_chunkMap[chunkX].Add(chunkY, chunk);


                return true;
            }


            return false;
        }

        public bool CreateChunkAt(int chunkX, int chunkY)
        {
            if (m_chunkMap.ContainsKey(chunkX) == false)
                m_chunkMap.Add(chunkX, new Dictionary<int, T[,]>());

            if (m_chunkMap[chunkX].ContainsKey(chunkY) == false)
            {
                var chunk = new T[ChunkSize, ChunkSize];

                for (int x = 0; x < ChunkSize; ++x)
                {
                    for (int y = 0; y < ChunkSize; ++y)
                    {
                        chunk[x, y] = new T();
                    }
                }


                m_chunkMap[chunkX].Add(chunkY, chunk);


                return true;
            }


            return false;
        }

        protected bool CreateChunkContainsItemAt(int itemX, int itemY)
        {
            int chunkX, chunkY;
            this.GetChunkPosContainsItemAt(itemX, itemY, out chunkX, out chunkY);


            return CreateChunkAt(chunkX, chunkY);
        }

        public T[,] GetChunkContainsItemAt(int x, int y)
        {
            int chunkX, chunkY;
            this.GetChunkPosContainsItemAt(x, y, out chunkX, out chunkY);

            if (m_chunkMap.ContainsKey(chunkX) && m_chunkMap[chunkX].ContainsKey(chunkY))
            {
                return m_chunkMap[chunkX][chunkY];
            }


            return null;
        }

        public T[,] GetChunkAt(int chunkX, int chunkY)
        {
            if (m_chunkMap.ContainsKey(chunkX) && m_chunkMap[chunkX].ContainsKey(chunkY))
            {
                return m_chunkMap[chunkX][chunkY];
            }


            return null;
        }

        //#####################################################################################

        public bool ContainsItemAt(int x, int y)
        {
            int chunkX, chunkY;
            this.GetChunkPosContainsItemAt(x, y, out chunkX, out chunkY);


            return (m_chunkMap.ContainsKey(chunkX) && m_chunkMap[chunkX].ContainsKey(chunkY));
        }

        public T GetItemAt(int x, int y)
        {
            // 아이템이 속하는 청크 좌표 얻기
            int chunkX, chunkY;
            this.GetChunkPosContainsItemAt(x, y, out chunkX, out chunkY);

            // 해당 좌표에 청크 생성 (이미 있으면 생성안함)
            this.CreateChunkAt(chunkX, chunkY);

            // 청크 얻어옴
            var chunk = m_chunkMap[chunkX][chunkY];

            // 청크가 있으면 아이템 얻어와 반환
            if (chunk != null)
            {
                int localX, localY;
                this.ItemPosToLocalPos(x, y, out localX, out localY);


                return chunk[localX, localY];
            }


            return default(T);
        }

        public void SetItemAt(T item, int x, int y)
        {
            // 아이템이 속하는 청크 좌표 얻기
            int chunkX, chunkY;
            this.GetChunkPosContainsItemAt(x, y, out chunkX, out chunkY);

            // 해당 좌표에 청크 생성 (이미 있으면 생성안함)
            this.CreateChunkAt(chunkX, chunkY);

            // 청크 얻어옴
            var chunk = m_chunkMap[chunkX][chunkY];

            // 청크가 있으면 해당 공간에 아이템 설정함
            if (chunk != null)
            {
                int localX, localY;
                this.ItemPosToLocalPos(x, y, out localX, out localY);


                chunk[localX, localY] = item;
            }
        }

        public T this[int x, int y]
        {
            get
            {
                return GetItemAt(x, y);
            }
            set
            {
                SetItemAt(value, x, y);
            }
        }

        //#####################################################################################

        public IEnumerable<ChunkInfo<T>> GetEnumerable()
        {
            foreach (var horizon in m_chunkMap)
            {
                foreach (var item in horizon.Value)
                {
                    yield return new ChunkInfo<T>
                    {
                        X = horizon.Key,
                        Y = item.Key,
                        Chunk = item.Value
                    };
                }
            }
        }
    }

    //#####################################################################################

    public class ChunkInfo<T>
    {
        public int X
        { get; set; }

        public int Y
        { get; set; }

        public T[,] Chunk
        { get; set; }
    }
}
