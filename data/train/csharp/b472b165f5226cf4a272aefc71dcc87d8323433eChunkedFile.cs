using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PacketCompare.Classes
{
    class ChunkedFile
    {
        private List<Chunk> _chunkList;
        private int _chunkSize;

        public ChunkedFile(string FileContents, int chunkSize)
        {
            _chunkSize = chunkSize;
            _chunkList = chunkString(FileContents, chunkSize);
        }

        public List<Chunk> chunkList
        {
            get { return _chunkList; }
            set { _chunkList = value; }
        }

        public int chunkSize
        {
            get { return _chunkSize; }
            set { _chunkSize = value; }
        }

        /// <summary>
        /// Create a list of string chunks of specified size.
        /// </summary>
        /// <param name="fileContents">String of the content to be chunked</param>
        /// <param name="chunkSize">Desired size of each chunk</param>
        /// <returns>List of chunks</returns>
        private List<Chunk> chunkString(string fileContents, int chunkSize)
        {
            List<Chunk> theChunkList = new List<Chunk>();
            for (int i = 0; i <= fileContents.Length - chunkSize; i++)
            {
                theChunkList.Add(new Chunk(fileContents.Substring(i, chunkSize), i));
            }
            return theChunkList;
        }

        /// <summary>
        /// Compares each chunk of a chunk list to another chunk list to see if any strings match
        /// </summary>
        /// <param name="comparisonFile">The file to compare</param>
        /// <returns>List of Chunks shared betweeen the two lists</returns>
        public List<Chunk> compareChunkLists(ChunkedFile comparisonFile)
        {
            List<Chunk> matchList = new List<Chunk>();

            for (int i = 0; i < _chunkList.Count; i++)
            {
                for (int j = 0; j < comparisonFile.chunkList.Count; j++)
                {
                    if (_chunkList.ElementAt<Chunk>(i).value.Equals(comparisonFile.chunkList.ElementAt<Chunk>(j).value))
                    {
                        matchList.Add(_chunkList.ElementAt<Chunk>(i));
                        break;
                    }
                }
            }
            return matchList;
        }

        /// <summary>
        /// Remove the duplicate chunks in terms of value from a chunk array
        /// </summary>
        public void eliminateDuplicates()
        {
            for (int i = 0; i <= chunkList.Count -1; i++)
            {
                for (int j = chunkList.Count-1; j >= i+1; j--)
                {
                    if(chunkList.ElementAt<Chunk>(i).value.Equals(chunkList.ElementAt<Chunk>(j).value))
                    {
                        chunkList.RemoveAt(j);
                    }
                }
            }
        }


        /// <summary>
        /// Reassambles the char chunks into longer char arrays if there are concurrent indexes
        /// </summary>
        /// <param name="inputList">The list to reassemble</param>
        /// <returns>The reassembled list</returns>
        public static List<Chunk> reassambleChunks(List<Chunk> inputList)
        {
            List<Chunk> reassembledChunks = new List<Chunk>();
            int previousIndex = -1;
            string reassembledChunk = "";
            int chunkSize = 0;
            if(inputList.Count>0)
                chunkSize = inputList.ElementAt<Chunk>(0).value.Length;

            for (int i = 0; i < inputList.Count; i++)
            {
                if (inputList.ElementAt<Chunk>(i).index == previousIndex + 1)
                {
                    previousIndex += 1;
                    reassembledChunk += inputList.ElementAt<Chunk>(i).value.Substring(chunkSize - 1, 1);
                }
                else
                {
                    if (previousIndex > -1)
                        reassembledChunks.Add(new Chunk(reassembledChunk, previousIndex - reassembledChunk.Length + chunkSize));
                    previousIndex = inputList.ElementAt<Chunk>(i).index;
                    reassembledChunk = inputList.ElementAt<Chunk>(i).value;
                }
            }
            reassembledChunks.Add(new Chunk(reassembledChunk, previousIndex - reassembledChunk.Length + chunkSize));
            return reassembledChunks;
        }
    }
}
