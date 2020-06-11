// Copyright eeGeo Ltd (2012-2014), All Rights Reserved

#pragma once

#include "Rendering.h"
#include "AsyncTexturing.h"
#include "Lighting.h"
#include "POD.h"
#include "Types.h"
#include "VectorMathDecl.h"
#include "SceneModelResourceRepository.h"
#include "SceneModelTextureResource.h"
#include "SceneModelMaterialResource.h"
#include "SceneModelMeshResource.h"
#include "SceneModelTriStripMeshResource.h"
#include "Helpers.h"
#include <string>
#include <vector>

namespace Eegeo
{
    namespace Rendering
    {
        namespace SceneModels
        {
            class SceneModelFactory
            {
            public:

                typedef SceneModelResourceRepository<SceneModelTextureResource, AsyncTexturing::IAsyncTexture> TTextureRepo;
                typedef SceneModelResourceRepository<SceneModelMaterialResource, Materials::SceneModelMaterial> TMaterialRepo;
                typedef SceneModelResourceRepository<SceneModelMeshResource, Mesh> TMeshRepo;
                typedef SceneModelResourceRepository<SceneModelTriStripMeshResource, TriStripMesh> TTriStripMeshRepo;
                
                SceneModelFactory(MeshFactories::SceneModelMeshFactory& meshFactory,
                                  VertexLayouts::VertexBindingPool& vertexBindingPool,
                                  Rendering::Shaders::ShaderIdGenerator& shaderIdGenerator,
                                  Rendering::Materials::MaterialIdGenerator& materialIdGenerator,
                                  Lighting::GlobalLighting& globalLighting,
                                  Lighting::GlobalFogging& globalFogging,
                                  TTextureRepo& textureRepo,
                                  TMaterialRepo& materialRepo,
                                  TMeshRepo& meshRepo,
                                  TTriStripMeshRepo& triStripMeshRepo);
                
                ~SceneModelFactory();
                
                void PreloadResourcesFromPodScene(const IO::POD::PODScene& podScene,
                                                  AsyncTexturing::IAsyncTextureRequestor& asyncTextureLoader,
                                                  TTextureRepo& textureRepo,
                                                  TMaterialRepo& materialRepo,
                                                  TMeshRepo& meshRepo,
                                                  TTriStripMeshRepo& triStripMeshRepo,
                                                  const std::string& filename,
                                                  const std::string& texturePath);
                void PreloadTexturesFromPodScene(const IO::POD::PODScene& podScene, TTextureRepo& textureRepo, AsyncTexturing::IAsyncTextureRequestor& asyncTextureLoader, const std::string& texturePath);
                void PreloadMaterialsFromPodScene(const IO::POD::PODScene& podScene,
                                                  TMaterialRepo& materialRepo,
                                                  ISceneModelResourceProvider<SceneModelTextureResource>& textureRepo,
                                                  const std::string& filename,
                                                  const std::string& texturePath );
                void PreloadMeshesFromPodScene(const IO::POD::PODScene& podScene, TMeshRepo& meshRepo, TTriStripMeshRepo& triStripMeshRepo, const std::string& filename);
                

                SceneModel* CreateSceneModelFromFile(const std::string& filename, Helpers::IFileIO& fileIO, AsyncTexturing::IAsyncTextureRequestor& asyncTextureLoader, const std::string& texturePath);
                SceneModel* CreateSceneModelFromPodScene(const IO::POD::PODScene& podScene, AsyncTexturing::IAsyncTextureRequestor& asyncTextureLoader, const std::string& filename, const std::string& texturePath);
                SceneModel* CreateSceneModelFromPodScene(const IO::POD::PODScene& podScene,
                                                         ISceneModelResourceProvider<SceneModelMaterialResource>& materialRepo,
                                                         ISceneModelResourceProvider<SceneModelMeshResource>& meshRepo,
                                                         ISceneModelResourceProvider<SceneModelTriStripMeshResource>& triStripMeshRepo,
                                                         const std::string& filename);
                
                SceneModelRenderableNode* CreateSceneModelNodeFromMesh(const std::string& name, SceneModelMeshResource& meshResource, SceneModelMaterialResource& materialResource);
                
            private:
                
                ISceneModelNodeAnimation* GetAnimationDataForNode(const IO::POD::PODNode& podNode, uint frameCount);
                void GetNonIndexedAnimationData(const IO::POD::PODNode& podNode, std::vector<v3>& out_positions, std::vector<Quaternion>& out_rotations, std::vector<v3>& out_scales);
                void GetIndexedAnimationData(const IO::POD::PODNode& podNode,
                                             u32 frameCount,
                                             std::vector<u32>& out_positionIndices,
                                             std::vector<u32>& out_rotationIndices,
                                             std::vector<u32>& out_scaleIndices);

                
                MeshFactories::SceneModelMeshFactory& m_meshFactory;
                VertexLayouts::VertexBindingPool& m_vertexBindingPool;
                Rendering::Shaders::ShaderIdGenerator& m_shaderIdGenerator;
                Rendering::Materials::MaterialIdGenerator& m_materialIdGenerator;
                Lighting::GlobalLighting& m_globalLighting;
                Lighting::GlobalFogging& m_globalFogging;
                Shaders::ModelShader* m_pShader;
            
                TTextureRepo& m_textureRepo;
                TMaterialRepo& m_materialRepo;
                TMeshRepo& m_meshRepo;
                TTriStripMeshRepo& m_triStripMeshRepo;
            };
        }
    }
}
