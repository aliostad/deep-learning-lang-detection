#include "stdafx.h"
#include "ModelLoader.h"
#include "Model.h"
#include "ModelShapes.h"
#include "ModelData.h"
#include "FBXLoader.h"
#include "Effect.h"
#include "Engine.h"
#include "ShaderManager.h"
#include "Surface.h"

CModelLoader::CModelLoader()
{

}	

CModelLoader::~CModelLoader()
{
}

CModel* CModelLoader::CreateShape(eModelShape aShape)
{
	CModel* newModel = new CModel();
	int blueprint = 1; // pos


	ID3D11VertexShader* vertexShader		= SHADERMGR->LoadVertexShader(L"Shaders/vertex_shader.fx", blueprint);
	ID3D11PixelShader* pixelShader			= SHADERMGR->LoadPixelShader(L"Shaders/pixel_shader.fx", blueprint);
	ID3D11GeometryShader* geometryShader	= nullptr;//CEngine::GetInstance()->GetShaderManager()->LoadGeometryShader(blueprint);
	ID3D11InputLayout* inputLayout			= SHADERMGR->LoadInputLayout(L"Shaders/vertex_shader.fx", blueprint);
	D3D_PRIMITIVE_TOPOLOGY topology			= D3D10_PRIMITIVE_TOPOLOGY_TRIANGLELIST;
	//Put effects in a manager mebe?
	CEffect* effect = new CEffect(vertexShader, pixelShader, geometryShader, inputLayout, topology);
	newModel->Initialize(effect, nullptr);

	switch (aShape)
	{
	case eModelShape::eTriangle:
		CreateTriangle(newModel);
		break;
	case eModelShape::eQuad:
		CreateQuad(newModel);
		break;
	case eModelShape::eCube:
		CreateCube(newModel);
		break;
	}
	

	return newModel;
}

void CModelLoader::LoadModel(const char * aPath, CModel* aNewModel) //TODO: FIX THIS SHIT.
{
	// MEBE move into model?!
	CFBXLoader loader;
	CLoaderModel* loadedModel = loader.LoadModel(aPath);
	assert(loadedModel != nullptr && "Failed To load model");
	int shaderType = loadedModel->myMeshes[0]->myShaderType;

	
	std::string modelPath = aPath;
	std::wstring directory = std::wstring(modelPath.begin(), modelPath.end());
	directory = directory.substr(0, directory.find_last_of('/') + 1);

	//for(int i = 0; loadedModel->myTextures.size(); ++i) later add all chanels (for now we only need diffuse & normal)
	//-----------------------------------------------------------------------//
	CU::GrowingArray<const wchar_t*> texturePaths;
	texturePaths.Init(8);

	//diffuse
	std::wstring diffuse = std::wstring(loadedModel->myTextures[0].begin(), loadedModel->myTextures[0].end());
	diffuse = directory + diffuse;
	const wchar_t* diffusePath = diffuse.c_str();

	//Roughness
	std::wstring roughness = std::wstring(loadedModel->myTextures[1].begin(), loadedModel->myTextures[1].end());
	roughness = directory + roughness;
	const wchar_t* roughnessPath = roughness.c_str();

	//AO
	std::wstring ambientOclution = std::wstring(loadedModel->myTextures[2].begin(), loadedModel->myTextures[2].end());
	ambientOclution = directory + ambientOclution;
	const wchar_t* AOPath = ambientOclution.c_str();
	
	//Emissive
	std::wstring emissive = std::wstring(loadedModel->myTextures[3].begin(), loadedModel->myTextures[3].end());
	emissive = directory + emissive;
	const wchar_t* emissivePath = emissive.c_str();

	//normal
	std::wstring normal = std::wstring(loadedModel->myTextures[5].begin(), loadedModel->myTextures[5].end());
	normal = directory + normal;
	const wchar_t* normalPath = normal.c_str();

	//metalness
	std::wstring metalness = std::wstring(loadedModel->myTextures[10].begin(), loadedModel->myTextures[10].end());
	metalness = directory + metalness;
	const wchar_t* metalnessPath = metalness.c_str();

	if (loadedModel->myTextures[0] == "")
		diffusePath = L"";
	texturePaths.Add(diffusePath);

	if (loadedModel->myTextures[1] == "")
		roughnessPath = L"";
	texturePaths.Add(roughnessPath);

	if (loadedModel->myTextures[2] == "")
		AOPath = L"";
	texturePaths.Add(AOPath);

	if (loadedModel->myTextures[3] == "")
		emissivePath = L"";
	texturePaths.Add(emissivePath);

	if (loadedModel->myTextures[5] == "")
		normalPath = L"";
	texturePaths.Add(normalPath);

	if (loadedModel->myTextures[10] == "")
		metalnessPath = L"";
	texturePaths.Add(metalnessPath);
	//--------------------------------------------------------------------------//
	
	ID3D11VertexShader* vertexShader		= SHADERMGR->LoadVertexShader(L"Shaders/vertex_shader.fx", shaderType);
	ID3D11PixelShader* pixelShader			= SHADERMGR->LoadPixelShader(L"Shaders/pixel_shader.fx", shaderType);
	ID3D11GeometryShader* geometryShader	= nullptr;// CEngine::GetInstance()->GetShaderManager()->LoadGeometryShader(L"Shaders/geometry_shader.fx", shaderType);
	ID3D11InputLayout* inputLayout			= SHADERMGR->LoadInputLayout(L"Shaders/vertex_shader.fx", shaderType);
	D3D_PRIMITIVE_TOPOLOGY topology			= D3D10_PRIMITIVE_TOPOLOGY_TRIANGLELIST;
	//Put effects in a manager mebe?
	CEffect* effect = new CEffect(vertexShader, pixelShader, geometryShader, inputLayout, topology);
	CSurface* surface = new CSurface(texturePaths);
	
	aNewModel->Initialize(effect, surface, loadedModel);
	delete loadedModel;
	loadedModel = nullptr;

}

void CModelLoader::CreateTriangle(CModel* aModel)
{
	//CU::GrowingArray<SVertexData>& modelVertices = aModel->GetVertices();
	//CU::GrowingArray<unsigned int>& modelIndices = aModel->GetIndices();


	//modelVertices.Init(36);

	//modelVertices.Add(SVertexData());
	//modelVertices[0].position.x = 0.0f;
	//modelVertices[0].position.y = -0.8f;
	//modelVertices[0].position.z = 0.5f;
	//modelVertices[0].position.w = 1.0f;

	//modelVertices.Add(SVertexData());
	//modelVertices[1].position.x = -0.8f;
	//modelVertices[1].position.y = 0.8f;
	//modelVertices[1].position.z = 0.5f;
	//modelVertices[1].position.w = 1.0f;

	//modelVertices.Add(SVertexData());
	//modelVertices[2].position.x = 0.8f;
	//modelVertices[2].position.y = 0.8f;
	//modelVertices[2].position.z = 0.5f;
	//modelVertices[2].position.w = 1.0f;

	//modelIndices.Add(0);
	//modelIndices.Add(1);
	//modelIndices.Add(2);
}

void CModelLoader::CreateQuad(CModel* aModel)
{
	/*CU::GrowingArray<SVertexData>& modelVertices = aModel->GetVertices();
	CU::GrowingArray<unsigned int>& modelIndices = aModel->GetIndices();

	CU::Vector4f topLeft = {-0.5f, -0.5f, 0.5f, 1.0f};
	CU::Vector4f topRight = { 0.5f, -0.5f, 0.5f, 1.0f };
	CU::Vector4f botLeft = { -0.5f, 0.5f, 0.5f, 1.0f };
	CU::Vector4f botRight = { 0.5f, 0.5f, 0.5f, 1.0f };

	modelVertices.Add(SVertexData());
	modelVertices[0].position = topLeft;

	modelVertices.Add(SVertexData());
	modelVertices[1].position = botLeft;

	modelVertices.Add(SVertexData());
	modelVertices[2].position = botRight;

	modelVertices.Add(SVertexData());
	modelVertices[3].position = topRight;

	modelIndices.Add(0);
	modelIndices.Add(1);
	modelIndices.Add(3);

	modelIndices.Add(3);
	modelIndices.Add(1);
	modelIndices.Add(2);*/
}

void CModelLoader::CreateCube(CModel* aModel)
{
	CU::GrowingArray<SVertexDataCube> modelVertices;// = aModel->GetVertices();
	CU::GrowingArray<unsigned int> modelIndices;// = aModel->GetIndices();

	modelVertices.Init(8);
	modelIndices.Init(36);

	modelVertices.Add(SVertexDataCube());
	modelVertices[0].position.x = -0.5f;
	modelVertices[0].position.y = 0.5f;
	modelVertices[0].position.z = -0.5f;
	modelVertices[0].position.w = 1.0f;

	//modelVertices[0].UV.u = 0.0f;
	//modelVertices[0].UV.v = 0.0f;

	modelVertices.Add(SVertexDataCube());
	modelVertices[1].position.x = -0.5f;
	modelVertices[1].position.y = 0.5f;
	modelVertices[1].position.z = 0.5f;
	modelVertices[1].position.w = 1.0f;

	//modelVertices[1].UV.u = 1.0f;
	//modelVertices[1].UV.v = 0.0f;

	modelVertices.Add(SVertexDataCube());
	modelVertices[2].position.x = 0.5f;
	modelVertices[2].position.y = 0.5f;
	modelVertices[2].position.z = 0.5f;
	modelVertices[2].position.w = 1.0f;

	//modelVertices[2].UV.u = 0.0f;
	//modelVertices[2].UV.v = 0.0f;

	modelVertices.Add(SVertexDataCube());
	modelVertices[3].position.x = 0.5f;
	modelVertices[3].position.y = 0.5f;
	modelVertices[3].position.z = -0.5f;
	modelVertices[3].position.w = 1.0f;

	//modelVertices[3].UV.u = 1.0f;
	//modelVertices[3].UV.v = 0.0f;

	// BOT
	modelVertices.Add(SVertexDataCube());
	modelVertices[4].position.x = -0.5f;
	modelVertices[4].position.y = -0.5f;
	modelVertices[4].position.z = -0.5f;
	modelVertices[4].position.w = 1.0f;

	//modelVertices[4].UV.u = 0.0f;
	//modelVertices[4].UV.v = 1.0f;

	modelVertices.Add(SVertexDataCube());
	modelVertices[5].position.x = -0.5f;
	modelVertices[5].position.y = -0.5f;
	modelVertices[5].position.z = 0.5f;
	modelVertices[5].position.w = 1.0f;

	//modelVertices[5].UV.u = 1.0f;
	//modelVertices[5].UV.v = 1.0f;

	modelVertices.Add(SVertexDataCube());
	modelVertices[6].position.x = 0.5f;
	modelVertices[6].position.y = -0.5f;
	modelVertices[6].position.z = 0.5f;
	modelVertices[6].position.w = 1.0f;

	//modelVertices[6].UV.u = 0.0f;
	//modelVertices[6].UV.v = 1.0f;

	modelVertices.Add(SVertexDataCube());
	modelVertices[7].position.x = 0.5f;
	modelVertices[7].position.y = -0.5f;
	modelVertices[7].position.z = -0.5f;
	modelVertices[7].position.w = 1.0f;

	//modelVertices[7].UV.u = 1.0f;
	//modelVertices[7].UV.v = 1.0f;


	modelIndices.Add(0);
	modelIndices.Add(1);
	modelIndices.Add(2);
	modelIndices.Add(0);
	modelIndices.Add(2);
	modelIndices.Add(3);

	modelIndices.Add(4);
	modelIndices.Add(6);
	modelIndices.Add(5);
	modelIndices.Add(4);
	modelIndices.Add(7);
	modelIndices.Add(6);
	
	modelIndices.Add(4);
	modelIndices.Add(5);
	modelIndices.Add(1);
	modelIndices.Add(4);
	modelIndices.Add(1);
	modelIndices.Add(0);
	
	modelIndices.Add(6);
	modelIndices.Add(7);
	modelIndices.Add(3);
	modelIndices.Add(6);
	modelIndices.Add(3);
	modelIndices.Add(2);

	modelIndices.Add(4);
	modelIndices.Add(0);
	modelIndices.Add(3);
	modelIndices.Add(4);
	modelIndices.Add(3);
	modelIndices.Add(7);
	
	modelIndices.Add(6);
	modelIndices.Add(2);
	modelIndices.Add(1);
	modelIndices.Add(6);
	modelIndices.Add(1);
	modelIndices.Add(5);

	aModel->InitBuffers(modelVertices, modelIndices);
}
