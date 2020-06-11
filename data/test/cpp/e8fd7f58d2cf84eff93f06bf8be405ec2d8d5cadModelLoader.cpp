#include "Mashiro/Mashiro.h"
#include "ModelLoader.h"

ModelLoader* ModelLoader::mInstance = 0;

ModelLoader::ModelLoader() {
	mLoader = Mashiro::Scene::PMDFileLoader::create();
}

ModelLoader::~ModelLoader(){
}

ModelLoader* ModelLoader::instance() {
	return mInstance;
}

void ModelLoader::create() {
	ASSERT( !mInstance );
	mInstance = NEW ModelLoader();
}

void ModelLoader::destory() {
	ASSERT( mInstance );
	SAFE_DELETE( mInstance );
}

Mashiro::Scene::Model ModelLoader::createModel( const char* file ){
	Mashiro::Scene::Model model;

	model = mLoader.createModel( file );
	return model;
}