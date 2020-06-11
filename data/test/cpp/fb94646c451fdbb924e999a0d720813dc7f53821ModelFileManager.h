#ifndef INCLUDE_GUARD_ModelFileManager_H_
#define INCLUDE_GUARD_ModelFileManager_H_

#include <tchar.h>

#include "..\Model\ModelManager.h"
#include "..\Model\Model.h"

namespace MyModel
{
	enum ModelFiles{
		ModelSphere,
		ModelTestHuman,
		ModelMax,
	};

	char ModelFileNames[][256];
	
	class ModelFileManager
	{
	private:
		IModel** m_ModelFiles;

		ID3D11Device* m_pDevice;
		ID3D11DeviceContext* m_pDeviceContext;
		FbxManager* m_pFbxManager;
		FbxImporter* m_pFbxImporter;

	public:
		ModelFileManager(ID3D11Device* pDevice, ID3D11DeviceContext* pDeviceContext, FbxManager* pFbxManager, FbxImporter* pFbxImporter);
		~ModelFileManager();

		IModel* GetModelFile(ModelFiles num);

		void Release();
	};
}

#endif

