
//using System.Collections;
//using System.Collections.Generic;
//namespace PlanetGrapher
//{
//    public class PlanetChunkEnumerator : IEnumerator<PlanetCell>
//    {
//        public PlanetChunkEnumerator(PlanetChunk chunk)
//        {
//            Chunk = chunk;
//            index = -1;
//        }

//        private PlanetChunk Chunk { get; set; }
//        private PlanetGraph Graph { get { return Chunk.Graph; } }
//        private int ChunkIndex { get { return Chunk.Identity; } }
//        private int index;
//        private int ChunkSize { get { return Graph.ChunkSize; } }
//        private int ChunkOffset { get { return ChunkIndex * ChunkSize; } }
//        private int ChunkEnd { get { return ChunkOffset + ChunkSize; } }
//        private int CellEnd { get { return Graph.CellLookup.Length; } }
//        private int CurrentIndex { get { return ChunkOffset + index; } }
//        public PlanetCell Current
//        {
//            get
//            {
//                if (index == -1)
//                    return null;
//                return Graph.CellLookup[CurrentIndex];
//            }
//        }

//        object IEnumerator.Current
//        {
//            get { return Current; }
//        }

//        public void Dispose()
//        {
//            //Do nothing
//        }

//        public bool MoveNext()
//        {
//            index++;
//            return (CurrentIndex < ChunkEnd && CurrentIndex < CellEnd);
//        }

//        public void Reset()
//        {
//            throw new System.NotImplementedException();
//        }
//    }
//}