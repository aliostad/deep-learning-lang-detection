#include "ModelManager.h"
#include "Global.h"

using namespace std;
using namespace DirectX;
using namespace DirectX::SimpleMath;

//*********************************************************************
// コンストラクタ
//*********************************************************************
ModelManager::ModelManager()
{
	
}


//*********************************************************************
// デストラクタ
//*********************************************************************
ModelManager::~ModelManager()
{

}


//*********************************************************************
// モデルの登録
//*********************************************************************
Model* ModelManager::EntryModel(eModels modelNumber, const wchar_t* modelName)
{
	// モデルの読み込み
	Model* model;
	model = Model::CreateFromCMO(g_pd3dDevice, L"Cube.cmo", *g_FXFactory).get();

	// マップ登録
	_models.insert( map<eModels, Model*>::value_type( modelNumber, model ));

	return nullptr;
}


//*********************************************************************
// モデルのポインタ取得
//*********************************************************************
Model* ModelManager::GetModel(eModels modelNumber)
{

	return nullptr;
}
