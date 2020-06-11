using System;
using System.Linq;
using System.Text;
using System.Threading;
using System.Collections.Generic;
using OpenTK;
using OpenTK.Audio;
using OpenTK.Input;
using OpenTK.Graphics;
using OpenTK.Platform;
using OpenTK.Audio.OpenAL;
using OpenTK.Graphics.OpenGL;
using Umbra.Engines;
using Umbra.Utilities;
using Umbra.Structures;
using Umbra.Definitions;
using Umbra.Implementations;
using Umbra.Structures.Geometry;
using Umbra.Definitions.Globals;
using Umbra.Implementations.Graphics;
using Console = Umbra.Implementations.Graphics.Console;

namespace Umbra.Structures
{
    public class ChunkQueue
    {
        List<Chunk> ChunkList;
        public int Count
        {
            get { return ChunkList.Count; }
        }

        public ChunkQueue()
        {
            ChunkList = new List<Chunk>();
        }

        public Chunk this[int i]
        {
            get
            {
                if (i >= 0 || i < Count)
                {
                    return ChunkList.ElementAt(i);
                }
                else
                {
                    throw new Exception("Index was out of bounds!");
                }
            }
            set
            {
                if (i >= 0 && i < Count)
                {
                    Chunk chunk = ChunkList.ElementAt(i);
                    ChunkList.Remove(chunk);
                    ChunkList.Insert(i, chunk);
                }
                else
                {
                    throw new Exception("Index was out of bounds!");
                }
            }
        }



        public void AddSorted(Chunk chunk)
        {
            if (Contains(chunk))
            {
                return;
            }

            if (Count == 0 || chunk == null)
            {
                Enqueue(chunk);
                return;
            }

            for (int i = 0; i < Count; i++)
            {
                Chunk tempChunk;
                try
                {
                    tempChunk = this[i];
                }
                catch (Exception e)
				{
					try
					{
						tempChunk = this[i];
					}
					catch (Exception e2)
					{
						Popup.Post("EXCEPTION222222222!!!!! " + e2.Message);
						Enqueue(chunk);
						return;
					}
                    Popup.Post("EXCEPTION!!!!! " + e.Message);
                    Enqueue(chunk);
                    return;
                }

                ChunkIndex modified = chunk.Index * new ChunkIndex(1, 1, 1);
                if (tempChunk != null)
                {
                    int val = ((modified.Position - Constants.Engines.Physics.Player.Position).LengthSquared).CompareTo((tempChunk.Index.Position - Constants.Engines.Physics.Player.Position).LengthSquared);

                    if (val > 0)
                    {
                        ChunkList.Insert(i, chunk);
                        return;
                    }
                    else if (val <= 0)
                    {
                        continue;
                    }
                }
            }

            Enqueue(chunk);
        }

        public void Enqueue(Chunk chunk)
        {
            ChunkList.Add(chunk);
        }

        public Chunk Dequeue()
        {
            Chunk chunk = ChunkList.Last();
            ChunkList.RemoveAt(ChunkList.Count - 1);

            return chunk;
        }

        public bool Contains(Chunk chunk)
        {
            return ChunkList.Contains(chunk);
        }

        public void Remove(Chunk chunk)
        {
            if (ChunkList.Contains(chunk))
            {
                ChunkList.Remove(chunk);
            }
        }

        public Chunk RemoveAt(int index)
        {
            Chunk chunk = ChunkList.ElementAt(index);
            ChunkList.RemoveAt(index);

            return chunk;
        }

        public Chunk Peek()
        {
            return ChunkList.Last();
        }
    }
}
