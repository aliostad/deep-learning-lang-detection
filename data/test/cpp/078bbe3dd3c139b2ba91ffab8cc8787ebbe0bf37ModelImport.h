#ifndef _MODEL_IMPORT_
#define _MODEL_IMPORT_

#ifdef __ANDROID__

class ModelImport
{
public:
	ModelImport();
};

#else

#include "Model.h"

struct aiNode;
struct aiScene;

// importer from a aiScene
class ModelImport
{
public:
	ModelImport();

	bool Import( const aiScene* scene, Model* newModel );

private:
	bool ImportBones( const aiScene* scene, Model* newModel );
	int  createSkeleton( const aiNode* node, int parentIndex, vector<Model::Bone>* skeleton );

	bool ImportMeshes( const aiScene* scene, Model* newModel );

	bool ImportBoneAnimations( const aiScene* scene, Model* newModel );
	bool ImportMorphAnimations( const aiScene* scene, Model* newModel );
	bool ImportMaterials( const aiScene* scene, Model* newModel );
};

#endif



#endif
