using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace AISTek.XRage.Graphics
{
    public class RenderChunkManager : XComponent
    {
        public RenderChunkManager(XGame game)
            : base(game)
        { }

        #region Public properties

        public IList<GeometryRenderChunk> GeometryRenderChunks { get { return geometryChunkList; } }

        public IList<LightRenderChunk> LightRenderChunks { get { return lightChunkList; } }

        public IList<ParticleChunk> ParticleChunks { get { return particleChunkList; } }
        
        #endregion

        #region Public methods

        #region Render chunks allocation and releasing

        public GeometryRenderChunk AllocateGeometryChunk()
        {
            return AllocateChunk(geometryChunkList, deadGeometryChunkList);
        }

        public void ReleaseGeometryChunk(GeometryRenderChunk chunk)
        {
            ReleaseChunk(chunk, deadGeometryChunkList);
        }

        public LightRenderChunk AllocateLightChunk()
        {
            return AllocateChunk(lightChunkList, deadLightChunkList);
        }

        public void ReleaseLightChunk(LightRenderChunk chunk)
        {
            ReleaseChunk(chunk, deadLightChunkList);
        }

        public ParticleChunk AllocateParticleChunk()
        {
            return AllocateChunk(particleChunkList, deadParticleChunkList);
        }

        public void ReleaseParticleChunk(ParticleChunk chunk)
        {
            ReleaseChunk(chunk, deadParticleChunkList);
        }

        #endregion

        public void PreallocateChunks(int geometryRenderChunksToPreallocate, int lightRenderChunksToPreallocate)
        {
            for (var i = 0; i < geometryRenderChunksToPreallocate; i++)
            {
                deadGeometryChunkList.Add(new GeometryRenderChunk());
            }

            for (var i = 0; i < lightRenderChunksToPreallocate; i++)
            {
                deadLightChunkList.Add(new LightRenderChunk());
            }
        }

        public void ClearChunks()
        {
            ClearChunks(geometryChunkList, deadGeometryChunkList);
            ClearChunks(lightChunkList, deadLightChunkList);
            ClearChunks(particleChunkList, deadParticleChunkList);
        }

        #endregion

        #region Private methods

        private T AllocateChunk<T>(List<T> chunkList, List<T> deadChunkList)
         where T : IRenderChunk, new()
        {
            if (deadChunkList.Count > 0)
            {
                var chunk = deadChunkList[deadChunkList.Count - 1];
                deadChunkList.RemoveAt(deadChunkList.Count - 1);

                chunkList.Add(chunk);

                return chunk;
            }
            else
            {
                var chunk = new T();
                chunkList.Add(chunk);
                return chunk;
            }
        }

        private void ReleaseChunk<T>(T chunk, List<T> deadChunkList)
            where T : IRenderChunk, new()
        {
            chunk.Recycle();
            deadChunkList.Add(chunk);
        }

        private void ClearChunks<T>(List<T> chunkList, List<T> deadChunkList)
           where T : IRenderChunk, new()
        {
            for (int i = 0; i < chunkList.Count; ++i)
            {
                chunkList[i].Recycle();
                deadChunkList.Add(chunkList[i]);
            }
            chunkList.Clear();
        }

        #endregion

        #region Private fields

        private List<GeometryRenderChunk> geometryChunkList = new List<GeometryRenderChunk>();

        private List<GeometryRenderChunk> deadGeometryChunkList = new List<GeometryRenderChunk>();


        private List<LightRenderChunk> lightChunkList = new List<LightRenderChunk>();

        private List<LightRenderChunk> deadLightChunkList = new List<LightRenderChunk>();


        private List<ParticleChunk> particleChunkList = new List<ParticleChunk>();

        private List<ParticleChunk> deadParticleChunkList = new List<ParticleChunk>();

        #endregion
    }
}
