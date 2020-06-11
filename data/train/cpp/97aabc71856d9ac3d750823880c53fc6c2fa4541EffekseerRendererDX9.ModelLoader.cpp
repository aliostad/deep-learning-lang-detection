
#ifdef __EFFEKSEER_RENDERER_INTERNAL_LOADER__

//----------------------------------------------------------------------------------
// Include
//----------------------------------------------------------------------------------
#include "EffekseerRendererDX9.Renderer.h"
#include "EffekseerRendererDX9.ModelLoader.h"

//-----------------------------------------------------------------------------------
//
//-----------------------------------------------------------------------------------
namespace EffekseerRendererDX9
{
//----------------------------------------------------------------------------------
//
//----------------------------------------------------------------------------------
ModelLoader::ModelLoader( Renderer* renderer, ::Effekseer::FileInterface* fileInterface )
	: m_renderer		( renderer )
	, m_fileInterface	( fileInterface )
{
	if( m_fileInterface == NULL )
	{
		m_fileInterface = &m_defaultFileInterface;
	}
}

//----------------------------------------------------------------------------------
//
//----------------------------------------------------------------------------------
ModelLoader::~ModelLoader()
{

}

//----------------------------------------------------------------------------------
//
//----------------------------------------------------------------------------------
void* ModelLoader::Load( const EFK_CHAR* path )
{
	std::auto_ptr<::Effekseer::FileReader> 
		reader( m_fileInterface->OpenRead( path ) );
	if( reader.get() == NULL ) return false;

	if( reader.get() != NULL )
	{
		HRESULT hr;

		size_t size_model = reader->GetLength();
		uint8_t* data_model = new uint8_t[size_model];
		reader->Read( data_model, size_model );

		Model* model = new Model( data_model, size_model );

		model->ModelCount = Effekseer::Min( Effekseer::Max( model->GetModelCount(), 1 ), 40);

		model->VertexCount = model->GetVertexCount();

		IDirect3DVertexBuffer9* vb = NULL;
		hr = m_renderer->GetDevice()->CreateVertexBuffer(
			sizeof(Effekseer::Model::VertexWithIndex) * model->VertexCount * model->ModelCount,
			D3DUSAGE_WRITEONLY,
			0,
			D3DPOOL_MANAGED,
			&vb,
			NULL );

		if( FAILED( hr ) )
		{
			/* DirectX9Ex‚Å‚ÍD3DPOOL_MANAGEDŽg—p•s‰Â */
			hr = m_renderer->GetDevice()->CreateVertexBuffer(
				sizeof(Effekseer::Model::VertexWithIndex) * model->VertexCount * model->ModelCount,
				D3DUSAGE_WRITEONLY,
				0,
				D3DPOOL_DEFAULT,
				&vb,
				NULL );
		}

		if( vb != NULL )
		{
			uint8_t* resource = NULL;
			vb->Lock( 0, 0, (void**)&resource, 0 );

			for(int32_t m = 0; m < model->ModelCount; m++ )
			{
				for( int32_t i = 0; i < model->GetVertexCount(); i++ )
				{
					Effekseer::Model::VertexWithIndex v;
					v.Position = model->GetVertexes()[i].Position;
					v.Normal = model->GetVertexes()[i].Normal;
					v.Binormal = model->GetVertexes()[i].Binormal;
					v.Tangent = model->GetVertexes()[i].Tangent;
					v.UV = model->GetVertexes()[i].UV;
					v.Index[0] = m;

					memcpy( resource, &v, sizeof(Effekseer::Model::VertexWithIndex) );
					resource += sizeof(Effekseer::Model::VertexWithIndex);
				}
			}

			vb->Unlock();
		}

		model->VertexBuffer = vb;

		model->FaceCount = model->GetFaceCount();
		model->IndexCount = model->FaceCount * 3;
		IDirect3DIndexBuffer9* ib = NULL;
		hr = m_renderer->GetDevice()->CreateIndexBuffer( 
			sizeof(Effekseer::Model::Face) * model->FaceCount * model->ModelCount,
			D3DUSAGE_WRITEONLY, 
			D3DFMT_INDEX32, 
			D3DPOOL_MANAGED, 
			&ib, 
			NULL );

		if( FAILED( hr ) )
		{
			hr = m_renderer->GetDevice()->CreateIndexBuffer( 
				sizeof(Effekseer::Model::Face) * model->FaceCount * model->ModelCount,
				D3DUSAGE_WRITEONLY, 
				D3DFMT_INDEX32, 
				D3DPOOL_DEFAULT, 
				&ib, 
				NULL );
		}

		if( ib != NULL )
		{
			uint8_t* resource = NULL;
			ib->Lock( 0, 0, (void**)&resource, 0 );
			for(int32_t m = 0; m < model->ModelCount; m++ )
			{
				for( int32_t i = 0; i < model->FaceCount; i++ )
				{
					Effekseer::Model::Face f;
					f.Indexes[0] = model->GetFaces()[i].Indexes[0] + model->GetVertexCount() * m;
					f.Indexes[1] = model->GetFaces()[i].Indexes[1] + model->GetVertexCount() * m;
					f.Indexes[2] = model->GetFaces()[i].Indexes[2] + model->GetVertexCount() * m;

					memcpy( resource, &f, sizeof(Effekseer::Model::Face) );
					resource += sizeof(Effekseer::Model::Face);
				}
			}
			
			ib->Unlock();
		}

		model->IndexBuffer = ib;

		delete [] data_model;

		return (void*)model;
	}

	return NULL;
}

//----------------------------------------------------------------------------------
//
//----------------------------------------------------------------------------------
void ModelLoader::Unload( void* data )
{
	if( data != NULL )
	{
		Model* model = (Model*)data;
		delete model;
	}
}

//----------------------------------------------------------------------------------
//
//----------------------------------------------------------------------------------
}
//----------------------------------------------------------------------------------
//
//----------------------------------------------------------------------------------

#endif // __EFFEKSEER_RENDERER_INTERNAL_LOADER__