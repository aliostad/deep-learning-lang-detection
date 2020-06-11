using Serveur.Framework;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Serveur.Tools
{
    class MapReducer : IReducer
    {
        string file;
        int chunkNumber;
        public MapReducer(string file, int chunkNumber)
        {
            this.file = file;
            this.chunkNumber = chunkNumber;
        }

        public List<string> CreateChunk()
        {
            List<string> chunk = new List<string>();
            string[] lines = File.ReadAllLines(file);
            int numberMaxLine = lines.Length;
            int chunkPart = numberMaxLine / 1000;
            int chunkState = chunkNumber * chunkPart;
            for(int i = chunkState; i <= chunkState + chunkPart; i++)
            {
                chunk.Add(lines[i]);
            }
            Console.WriteLine(chunk.Count);
            return chunk;
        }
    }
}
