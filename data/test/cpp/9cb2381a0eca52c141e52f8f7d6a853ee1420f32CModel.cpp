//=============================================================================
//
// モデル処理 [CModel.h]
// Author : 野尻　尚希
//
//=============================================================================
//*****************************************************************************
// インクルード
//*****************************************************************************
#include "CModel.h"
#include "../CONST/const.h"
#include "../TEXTURE/CTexture.h"

//*****************************************************************************
// 定数定義
//*****************************************************************************
// モデルのファイルパス
static const char *MODEL_PATH[ MODEL_MAX ] = 
{
	"../data/MODEL/ring.x",
	"../data/MODEL/front_chair.x",
	"../data/MODEL/over_chair.x",
	"../data/MODEL/side_chair.x",
	"../data/MODEL/stage.x",
}; 

//*****************************************************************************
// マクロ定義
//*****************************************************************************
static const int LENGTH_MAX = 256;	// 最大文字数

//*****************************************************************************
// スタティックメンバ変数宣言
//*****************************************************************************
X_MODEL					CModel::m_Model[MODEL_MAX] = {NULL};

//=============================================================================
// 初期化処理
//=============================================================================
HRESULT CModel::Init( LPDIRECT3DDEVICE9 *pDevice )
{
	LPD3DXBUFFER pD3DXAdjacencyBuff;		// 隣接情報バッファ

	// ゲームで使う全モデルを作成
	for(int modelCnt = 0; modelCnt < MODEL_MAX; modelCnt++)
	{
		// モデルの初期化
		if(FAILED(D3DXLoadMeshFromX(MODEL_PATH[modelCnt]	// 読み込むファイル名
									, D3DXMESH_SYSTEMMEM
									, *pDevice
									, &pD3DXAdjacencyBuff
									, &m_Model[modelCnt].pD3DXBuffMatModel
									, NULL
									, &m_Model[modelCnt].nNumMatModel
									, &m_Model[modelCnt].pD3DXMeshModel)))
		{
			return E_FAIL;
		}
		
		// オプティマイズ
		if(FAILED(m_Model[modelCnt].pD3DXMeshModel->OptimizeInplace(D3DXMESHOPT_COMPACT | D3DXMESHOPT_ATTRSORT | D3DXMESHOPT_VERTEXCACHE
														, (DWORD*)pD3DXAdjacencyBuff->GetBufferPointer()
														, NULL
														, NULL
														, NULL)))
		{
			return E_FAIL;
		}
		pD3DXAdjacencyBuff->Release();

		// 頂点要素配列を作る
		D3DVERTEXELEMENT9 elements[] =
		{
			// 頂点ストリーム(パイプライン)番号, オフセット(頂点の型の先頭からのバイト数), データ型, DEFAULTでＯＫ, 使用用途, 使用用途が同じものを複数使うときに仕分ける番号
			{0, 0, D3DDECLTYPE_FLOAT3, D3DDECLMETHOD_DEFAULT, D3DDECLUSAGE_POSITION, 0}		// 頂点 (D3DDECLUSAGE_POSITIONTは座標変換済み頂点を表す)
			, {0, 12, D3DDECLTYPE_FLOAT3, D3DDECLMETHOD_DEFAULT, D3DDECLUSAGE_NORMAL, 0}	// 法線
			, {0, 24, D3DDECLTYPE_FLOAT2, D3DDECLMETHOD_DEFAULT, D3DDECLUSAGE_TEXCOORD, 0}	// UV
			, D3DDECL_END()																	// 宣言の終了
		};

		// 頂点宣言したものを作る
		(*pDevice)->CreateVertexDeclaration(elements, &m_Model[modelCnt].m_pDecl);

		// クローン作製
		LPD3DXMESH pOldMesh = m_Model[modelCnt].pD3DXMeshModel;
		pOldMesh->CloneMesh(D3DXMESH_MANAGED
							, elements
							, *pDevice
							, &m_Model[modelCnt].pD3DXMeshModel);
		pOldMesh->Release();

		// マテリアルの数分作る
		m_Model[modelCnt].pD3DTexBuff = new LPDIRECT3DTEXTURE9[(int)m_Model[modelCnt].nNumMatModel];

		D3DXMATERIAL* d3dxmatrs = (D3DXMATERIAL*)m_Model[modelCnt].pD3DXBuffMatModel->GetBufferPointer();

		for(int i = 0; i < (int)m_Model[modelCnt].nNumMatModel; i++)
		{
			//テクスチャをロード
			m_Model[modelCnt].pD3DTexBuff[i] = NULL;
		
			d3dxmatrs[i].MatD3D.Ambient = d3dxmatrs[i].MatD3D.Diffuse;
			d3dxmatrs[i].MatD3D.Ambient.r *= 0.3f;
			d3dxmatrs[i].MatD3D.Ambient.g *= 0.3f;
			d3dxmatrs[i].MatD3D.Ambient.b *= 0.3f;

			// テクスチャの処理
			char temp[LENGTH_MAX];
			if(d3dxmatrs[i].pTextureFilename != NULL)
			{
				//中身初期化
				ZeroMemory(temp, sizeof(char) * LENGTH_MAX);

				//文字列連結
				strcat(temp, TEX_FOLDER_PATH);
				strcat(temp, d3dxmatrs[i].pTextureFilename);
				
				//テクスチャ読み込み
				if(FAILED(D3DXCreateTextureFromFile(*pDevice, temp, &m_Model[modelCnt].pD3DTexBuff[i])))
				{
					
					//assert(!"モデルのテクスチャがdataにない！");
					ZeroMemory(temp, sizeof(char)* LENGTH_MAX);

					//文字列連結
					strcat(temp, TEX_FOLDER_PATH);
					strcat(temp, "default.png");

					//テクスチャ読み込み
					if (FAILED(D3DXCreateTextureFromFile(*pDevice, temp, &m_Model[modelCnt].pD3DTexBuff[i])))
					{
#ifdef _DEBUG
						assert(!"default.pngがdataにない！");
#endif
					}
				}
			}
			else
			{
				//中身初期化
				ZeroMemory(temp, sizeof(char) * LENGTH_MAX);
			
				//文字列連結
				strcat(temp, TEX_FOLDER_PATH);
				strcat(temp, "default.png");
				
				//テクスチャ読み込み
				if(FAILED(D3DXCreateTextureFromFile(*pDevice, temp, &m_Model[modelCnt].pD3DTexBuff[i])))
				{
#ifdef _DEBUG
					assert(!"default.pngがdataにない！");
#endif
				}
			}
		}

		// Xファイルに法線がない場合は、法線を書き込む
		if (!(m_Model[modelCnt].pD3DXMeshModel->GetFVF() & D3DFVF_NORMAL))
		{
			ID3DXMesh* pTempMesh = NULL;
			
			m_Model[modelCnt].pD3DXMeshModel->CloneMeshFVF(m_Model[modelCnt].pD3DXMeshModel->GetOptions()
															, m_Model[modelCnt].pD3DXMeshModel->GetFVF()|D3DFVF_NORMAL
															, *pDevice
															, &pTempMesh);
		
			D3DXComputeNormals(pTempMesh, NULL);
			m_Model[modelCnt].pD3DXMeshModel->Release();
			m_Model[modelCnt].pD3DXMeshModel = pTempMesh;
		}

		// インデックス情報を保存
		LPDIRECT3DINDEXBUFFER9 index_buffer;	// インデックスバッファ
		WORD* pIndices;							// ポリゴン構成（頂点リンク）データへのポインタ
		WORD* pIndices_2;						// ポリゴン構成（頂点リンク）データへのポインタ
		
		// インデックスバッファオブジェクトへのポインタをゲット
		m_Model[modelCnt].pD3DXMeshModel->GetIndexBuffer(&index_buffer);

		// 面の数取得
		int numFace = m_Model[modelCnt].pD3DXMeshModel->GetNumFaces();

		// インデックスを頂点数分作る
		m_Model[modelCnt].pIndex = new WORD[numFace * NUM_POLYGON_CREATE_TRIANGLE];
		pIndices_2 = m_Model[modelCnt].pIndex;

		// インデックスバッファをロック
		index_buffer ->Lock(0, 0, (void**)&pIndices , 0);

		// インデックスデータをワークにコピー
		memcpy(pIndices_2, pIndices, sizeof(WORD)*numFace * NUM_POLYGON_CREATE_TRIANGLE);
		
		// インデックスバッファをアンロック
		index_buffer ->Unlock();

		// 解放
		index_buffer->Release();

		// 頂点情報保存
		LPDIRECT3DVERTEXBUFFER9 vertex_buffer;	// 頂点バッファ
		VERTEX* pVertices;						// 頂点データへのポインタ
		VERTEX* pVertices_2;					// 頂点データへのポインタ

		// 頂点バッファオブジェクトへのポインタをゲット
		m_Model[modelCnt].pD3DXMeshModel->GetVertexBuffer(&vertex_buffer);

		// 頂点数をゲット
		int numVertex = m_Model[modelCnt].pD3DXMeshModel->GetNumVertices();
		
		// 頂点の数分作る
		m_Model[modelCnt].pVertex = new VERTEX[numVertex];
		pVertices_2 = m_Model[modelCnt].pVertex;

		// 頂点バッファをロック
		vertex_buffer->Lock(0, 0, (void**)&pVertices, 0);

		// 頂点データをワークにコピー
		memcpy(pVertices_2, pVertices, sizeof(VERTEX)*numVertex);

		// 頂点バッファをアンロック
		vertex_buffer->Unlock();

		// 解放
		vertex_buffer->Release();
	}
	return S_OK;
}

//=============================================================================
// 終了処理
//=============================================================================
void CModel::Uninit( void )
{
	// 使った全テクスチャポインタを開放
	for( int modelCnt = 0; modelCnt < MODEL_MAX; modelCnt++ )
	{
		if(m_Model[modelCnt].pD3DTexBuff)
		{
			for (int i = 0; i < (int)m_Model[modelCnt].nNumMatModel; i++)
			{
				if(m_Model[modelCnt].pD3DTexBuff[i])
				{
					(m_Model[modelCnt].pD3DTexBuff[i])->Release();
					(m_Model[modelCnt].pD3DTexBuff[i]) = NULL;
				}
			}
			delete[] m_Model[modelCnt].pD3DTexBuff;
			m_Model[modelCnt].pD3DTexBuff = NULL;
		}

		if(m_Model[modelCnt].pD3DXMeshModel)
		{
			m_Model[modelCnt].pD3DXMeshModel->Release();
			m_Model[modelCnt].pD3DXMeshModel = NULL;
		}

		if(m_Model[modelCnt].pD3DXBuffMatModel)
		{
			m_Model[modelCnt].pD3DXBuffMatModel->Release();
			m_Model[modelCnt].pD3DXBuffMatModel = NULL;
		}

		if(m_Model[modelCnt].pIndex)
		{
			delete[] m_Model[modelCnt].pIndex;
			m_Model[modelCnt].pIndex = NULL;
		}

		if(m_Model[modelCnt].pVertex)
		{
			delete[] m_Model[modelCnt].pVertex;
			m_Model[modelCnt].pVertex = NULL;
		}

		if (m_Model[modelCnt].m_pDecl)
		{
			m_Model[modelCnt].m_pDecl->Release();
			m_Model[modelCnt].m_pDecl = NULL;
		}
	}
}

//=============================================================================
// モデル作成処理
//=============================================================================
void CModel::CreateModel( LPDIRECT3DDEVICE9 *pDevice)
{
	CModel::Init( pDevice);
}

//=============================================================================
// モデル情報ゲット
//=============================================================================
X_MODEL* CModel::GetModel(MODEL_TYPE type)
{
#ifdef _DEBUG
	assert((type >= 0 && type < MODEL_MAX)&& "不正なモデルタイプ！");
#endif
	return &m_Model[type];
}

X_MODEL* CModel::GetModel(char* fileName)
{
	// 作ってあるもののファイルパスと比較してあったら返す
	for(int i = 0; i < MODEL_MAX; i++)
	{
		if(strcmp(MODEL_PATH[i], fileName) == 0)
		{
			return &m_Model[i];
		}
	}
#ifdef _DEBUG
	assert(!"不正なファイルパス！");
#endif
	return NULL;
}
//----EOF----