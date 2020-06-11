using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ImageCompressor
{
    //a chunk is just a 2d array. Implemented to avoid 4d arrays, a 2dchunk array is still a 4d array but easier to work with.
    public class Chunk
    {
        public int[][] chunk{ get; set; }

        public Chunk()
        {
            this.chunk = new int[8][];
            for (int i = 0; i < 8; i++)
            {
                chunk[i] = new int[8];
            }
        }

        public Chunk(int[][] a)
        {
            this.chunk = a;
        }
        //implicitly cast in[][] to chunk
        public static implicit operator int[][](Chunk value)
        {
            return value.chunk;
        }
        public static implicit operator Chunk(int[][] value)
        {
            Chunk t = new Chunk();
            t.chunk = value;
            return t;
        }
        //direct element subtraction
        public static Chunk operator -(Chunk a, Chunk b)
        {
            int[][] t = new int[a.chunk.Length][];
            for (int i = 0; i < a.chunk.Length; i++)
            {
                t[i] = new int[a.chunk[i].Length];
                for (int j = 0; j < a.chunk[i].Length; j++)
                {
                    t[i][j] = a.chunk[i][j] - b.chunk[i][j];
                }
            }
            return new Chunk(t);
        }

        public override string ToString()
        {
            StringBuilder s = new StringBuilder("");
            for (int i = 0; i < chunk.Length; i++)
            {
                for (int j = 0; j < chunk[i].Length; j++)
                {
                    s.Append(chunk[i][j]);
                    s.Append(" ");
                }
                s.AppendLine();
            }
            s.AppendLine();
            return s.ToString();
        }

    }
}
