#include "ModelManager.h"

ModelManager::ModelManager(ID3D11Device* p_d3dDevice, ID3D11DeviceContext* p_context)
{
	m_d3dDevice = p_d3dDevice;
	m_context = p_context;
	m_arraySize = 0; 
}

ModelManager::~ModelManager()
{
	for(int i = 0; i < m_arraySize; i++)
	{
		delete m_modelList[i];
	}
}

Model* ModelManager::GetModelByName( string p_modelName )
{
	for (int i = 0; i < m_arraySize; i++)
	{
		if(m_modelList[i]->m_bufferName == p_modelName)
		{
			return m_modelList[i];
		}
	}
	return m_modelList[0];
}

void ModelManager::CreateModel( string p_modelName, string p_OBJFileName )
{
	ModelLoader* t_modelLoader = new ModelLoader(m_d3dDevice, m_context);

	m_modelList[m_arraySize] = t_modelLoader->AddStaticModel(p_modelName, p_OBJFileName);
	m_arraySize++;
	delete t_modelLoader;
}


