using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections;

using WestWood3D.Chunks;

namespace WestWood3D
{
    public class ChunkMap
    {
        private Hashtable chunkMap = new Hashtable();

        public ChunkMap()
        {
            initializeChunks();
        }

        ///<summary>
        ///Initializes all the chunk classes and adds them to a hashtable
        ///for lookup and retrieval based on their chunk ID;
        ///</summary>
        private void initializeChunks()
        {
            Chunk meshChunk 				        = new MeshChunk();
    	    Chunk hierarchyChunk 					= new HierarchyChunk();
    	    Chunk hierarchyHeaderChunk 				= new HierarchyHeaderChunk();
            Chunk pivotsChunk 						= new PivotsChunk();
            Chunk pivotFixupsChunk 					= new PivotFixupsChunk();
    	    Chunk hlodChunk		 					= new HlodChunk();
    	    Chunk hlodHeaderChunk					= new HlodHeaderChunk();
            Chunk hlodLodArrayChunk				    = new HlodLodArrayChunk();
            Chunk hlodSubObjectArrayHeaderChunk     = new HlodSubObjectArrayHeaderChunk();
            Chunk hlodSubObjectChunk				= new HlodSubObjectChunk();
            Chunk hlodProxyArrayChunk               = new HLodProxyArrayChunk();
            Chunk meshHeader3Chunk					= new MeshHeader3Chunk();
            Chunk verticesChunk					    = new VerticesChunk();
            Chunk vertexNormalsChunk				= new VertexNormalsChunk();
            Chunk trianglesChunk					= new TrianglesChunk();
            Chunk vertexShadeIndicesChunk			= new VertexShadeIndicesChunk();
            Chunk materialInfoChunk				    = new MaterialInfoChunk();
            Chunk vertexMaterialsChunk			    = new VertexMaterialsChunk();
            Chunk vertexMaterialChunk				= new VertexMaterialChunk();
            Chunk vertexMaterialNameChunk			= new VertexMaterialNameChunk();
            Chunk vertexMaterialInfoChunk			= new VertexMaterialInfoChunk();
            Chunk shadersChunk					    = new ShadersChunk();
            Chunk texturesChunk					    = new TexturesChunk();
            Chunk textureChunk					    = new TextureChunk();
            Chunk textureNameChunk				    = new TextureNameChunk();
            Chunk textureInfoChunk                  = new TextureInfoChunk();
            Chunk materialPassChunk				    = new MaterialPassChunk();
            Chunk vertexMaterialIdsChunk			= new VertexMaterialIdsChunk();
            Chunk shaderIdsChunk					= new ShaderIdsChunk();
            Chunk textureStageChunk				    = new TextureStageChunk();
            Chunk textureIdsChunk					= new TextureIdsChunk();
            Chunk stageTexCoordsChunk				= new StageTexCoordsChunk();
            Chunk aabTreeChunk					    = new AabTreeChunk();
            Chunk aabTreeHeaderChunk				= new AabTreeHeaderChunk();
            Chunk aabTreePolyIndicesChunk			= new AabTreePolyIndicesChunk();
            Chunk aabTreeNodesChunk			    	= new AabTreeNodesChunk();
            Chunk aggregateChunk					= new AggregateChunk();
            Chunk aggregateHeaderChunk			    = new AggregateHeaderChunk();
            Chunk aggregateInfoChunk				= new AggregateInfoChunk();
            Chunk aggregateClassInfoChunk			= new AggregateClassInfoChunk();
    	    Chunk textureReplacerChunk			    = new TextureReplacerChunk();
            Chunk vertexMapperArgs0Chunk			= new VertexMapperArgs0Chunk();
            Chunk vertexMapperArgs1Chunk			= new VertexMapperArgs1Chunk();
            Chunk animationChunk					= new AnimationChunk();
    	    Chunk animationHeaderChunk			    = new AnimationHeaderChunk();
    	    Chunk animationChannelChunk			    = new AnimationChannelChunk();
    	    Chunk bitChannelChunk					= new BitChannelChunk();
    	    Chunk emitterChunk					    = new EmitterChunk();
    	    Chunk emitterHeaderChunk				= new EmitterHeaderChunk();
    	    Chunk emitterUserDataChunk			    = new EmitterUserDataChunk();
    	    Chunk emitterInfoChunk				    = new EmitterInfoChunk();
    	    Chunk emitterInfo2Chunk				    = new EmitterInfo2Chunk();
    	    Chunk emitterPropsChunk				    = new EmitterPropsChunk();
    	    Chunk emitterRotationKeyframesChunk	    = new EmitterRotationKeyFramesChunk();
    	    Chunk emitterFrameKeyFramesChunk		= new EmitterFrameKeyFramesChunk();
    	    Chunk emitterBlurTimeKeyFramesChunk	    = new EmitterBlurTimeKeyFramesChunk();
    	    Chunk emitterLinePropertiesChunk		= new EmitterLinePropertiesChunk();
    	    Chunk vertexInfluencesChunk			    = new VertexInfluencesChunk();
            Chunk dcgChunk                          = new DcgChunk();
            Chunk hModelChunk                       = new HModelChunk();
            Chunk hModelHeaderChunk                 = new HModelHeaderChunk();
            Chunk hModelAuxDataChunk                = new HModelAuxDataChunk();
            Chunk nodeChunk                         = new NodeChunk();
            Chunk compressedAnimationChunk          = new CompressedAnimationChunk();
            Chunk compressedAnimationHeaderChunk    = new CompressedAnimationHeaderChunk();
            Chunk compressedAnimationChannelChunk   = new CompressedAnimationChannelChunk();
            Chunk compressedBitChannelChunk         = new CompressedBitChannelChunk();
            Chunk hLodAggregateArrayChunk           = new HLodAggregateArrayChunk();
            Chunk prelitUnlitChunk                  = new PrelitUnlitChunk();
            Chunk prelitVertexChunk                 = new PrelitVertexChunk();
            Chunk prelitLightMultiPassChunk         = new PrelitLightMultiPassChunk();
            Chunk prelitLightMultiTextureChunk      = new PrelitLightMultiTextureChunk();
            Chunk meshUserTextChunk                 = new MeshUserTextChunk();
            Chunk collectionChunk                   = new CollectionChunk();
            Chunk collectionHeaderChunk             = new CollectionHeaderChunk();
            Chunk collectionObjectNameChunk         = new CollectionObjectNameChunk();
            Chunk placeholderChunk                  = new PlaceholderChunk();
            Chunk transformNodeChunk                = new TransformNodeChunk();
            Chunk dazzleChunk                       = new DazzleChunk();
            Chunk dazzleNameChunk                   = new DazzleNameChunk();
            Chunk dazzleTypeNameChunk               = new DazzleTypeNameChunk();
            Chunk boxChunk                          = new BoxChunk();
            Chunk deformChunk                       = new DeformChunk();
            Chunk deformSetChunk                    = new DeformSetChunk();
            Chunk deformKeyframeChunk               = new DeformKeyframeChunk();
            Chunk deformDataChunk                   = new DeformDataChunk();

            //Animation
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_ANIMATION, animationChunk);
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_ANIMATION_HEADER, animationHeaderChunk);
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_ANIMATION_CHANNEL, animationChannelChunk);
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_BIT_CHANNEL, bitChannelChunk);

            // Aggregate
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_AGGREGATE, aggregateChunk);
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_AGGREGATE_HEADER, aggregateHeaderChunk);
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_AGGREGATE_INFO, aggregateInfoChunk);
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_AGGREGATE_CLASS_INFO, aggregateClassInfoChunk);
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_TEXTURE_REPLACER_INFO, textureReplacerChunk);

            //Collection
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_COLLECTION, collectionChunk);
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_COLLECTION_HEADER, collectionHeaderChunk);
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_COLLECTION_OBJ_NAME, collectionObjectNameChunk);
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_PLACEHOLDER, placeholderChunk);
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_TRANSFORM_NODE, transformNodeChunk);

            //Compressed Animation
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_COMPRESSED_ANIMATION, compressedAnimationChunk);
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_COMPRESSED_ANIMATION_HEADER, compressedAnimationHeaderChunk);
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_COMPRESSED_ANIMATION_CHANNEL, compressedAnimationChannelChunk);
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_COMPRESSED_BIT_CHANNEL, compressedBitChannelChunk);

            //Dazzle
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_DAZZLE, dazzleChunk);
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_DAZZLE_NAME, dazzleNameChunk);
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_DAZZLE_TYPENAME, dazzleTypeNameChunk);

            //Deform
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_DEFORM, deformChunk);
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_DEFORM_SET, deformSetChunk);
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_DEFORM_KEYFRAME, deformKeyframeChunk);
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_DEFORM_DATA, deformDataChunk);

            //Emitter
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_EMITTER, emitterChunk);
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_EMITTER_HEADER, emitterHeaderChunk);
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_EMITTER_USER_DATA, emitterUserDataChunk);
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_EMITTER_INFO, emitterInfoChunk);
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_EMITTER_INFOV2, emitterInfo2Chunk);
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_EMITTER_PROPS, emitterPropsChunk);
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_EMITTER_LINE_PROPERTIES, emitterLinePropertiesChunk);
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_EMITTER_ROTATION_KEYFRAMES, emitterRotationKeyframesChunk);
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_EMITTER_FRAME_KEYFRAMES, emitterFrameKeyFramesChunk);
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_EMITTER_BLUR_TIME_KEYFRAMES, emitterBlurTimeKeyFramesChunk);

            // Mesh
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_MESH, meshChunk);
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_MESH_HEADER3, meshHeader3Chunk);
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_VERTICES, verticesChunk);
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_VERTEX_NORMALS, vertexNormalsChunk);
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_TRIANGLES, trianglesChunk);
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_VERTEX_SHADE_INDICES, vertexShadeIndicesChunk);
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_MATERIAL_INFO, materialInfoChunk);
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_MESH_USER_TEXT, meshUserTextChunk);
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_VERTEX_MATERIALS, vertexMaterialsChunk);
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_VERTEX_MATERIAL, vertexMaterialChunk);
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_VERTEX_MATERIAL_NAME, vertexMaterialNameChunk);
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_VERTEX_MATERIAL_INFO, vertexMaterialInfoChunk);
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_SHADERS, shadersChunk);
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_TEXTURES, texturesChunk);
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_TEXTURE, textureChunk);
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_TEXTURE_NAME, textureNameChunk);
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_TEXTURE_INFO, textureInfoChunk);
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_MATERIAL_PASS, materialPassChunk);
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_TEXTURE_STAGE, textureStageChunk);
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_TEXTURE_IDS, textureIdsChunk);
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_STAGE_TEXCOORDS, stageTexCoordsChunk);
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_VERTEX_MATERIAL_IDS, vertexMaterialIdsChunk);
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_VERTEX_MAPPER_ARGS0, vertexMapperArgs0Chunk);
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_VERTEX_MAPPER_ARGS1, vertexMapperArgs1Chunk);
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_SHADER_IDS, shaderIdsChunk);
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_VERTEX_INFLUENCES, vertexInfluencesChunk);
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_AABTREE, aabTreeChunk);
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_AABTREE_HEADER, aabTreeHeaderChunk);
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_AABTREE_POLYINDICES, aabTreePolyIndicesChunk);
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_AABTREE_NODES, aabTreeNodesChunk);
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_DCG, dcgChunk);

            //Primitives
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_BOX, boxChunk);

            //Hierarchy
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_HIERARCHY, hierarchyChunk);
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_HIERARCHY_HEADER, hierarchyHeaderChunk);
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_PIVOTS, pivotsChunk);
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_PIVOT_FIXUPS, pivotFixupsChunk);

            //HLod 
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_HLOD, hlodChunk);
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_HLOD_HEADER, hlodHeaderChunk);
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_HLOD_LOD_ARRAY, hlodLodArrayChunk);
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_HLOD_SUB_OBJECT_ARRAY_HEADER, hlodSubObjectArrayHeaderChunk);
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_HLOD_SUB_OBJECT, hlodSubObjectChunk);
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_HLOD_AGGREGATE_ARRAY, hLodAggregateArrayChunk);
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_HLOD_PROXY_ARRAY, hlodProxyArrayChunk);

            //HModel
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_HMODEL, hModelChunk);
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_HMODEL_HEADER, hModelHeaderChunk);
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_HMODEL_AUX_DATA, hModelAuxDataChunk);
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_NODE, nodeChunk);

            //Optional
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_PRELIT_UNLIT, prelitUnlitChunk);
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_PRELIT_VERTEX, prelitVertexChunk);
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_PRELIT_LIGHTMAP_MULTI_PASS, prelitLightMultiPassChunk);
            chunkMap.Add((int)ChunkHeader.W3D_CHUNK_PRELIT_LIGHTMAP_MULTI_TEXTURE, prelitLightMultiTextureChunk);

        }

        ///<summary>
        ///Looks up the chunk base type, creates and returns a new chunk class instance.
        ///</summary>
        public Chunk getChunk(int chunkID)
        {
            Chunk newChk = null;
            try
            {
                Chunk chk = (Chunk)chunkMap[chunkID];
                Type chkType = chk.GetType();
                if (chk != null)
                {
                    newChk = (Chunk) Activator.CreateInstance(chkType);
                }
            }
            catch (Exception)
            {
                return null;
            }
            return newChk;
        }
    }
}
