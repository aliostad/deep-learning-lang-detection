#include "../include/model.h"
#include "../include/mesh.h"
#include "../include/submesh.h"

//---------------------------------
//
//---------------------------------
Ptr<Model> Model::Create(Ptr<Mesh> mesh)
{   
    if( mesh != nullptr ) 
    {
        return Ptr<Model>( new Model( mesh ) );
    }

    return NULL;
}
//---------------------------------
//
//---------------------------------
void Model::Render()
{
	Entity::Render();
	mesh->Render  ();
}
//---------------------------------
//
//---------------------------------
Model::Model(Ptr<Mesh> mesh) : mesh( mesh )
{
    
}
//---------------------------------
//
//---------------------------------
Model::~Model()
{
}