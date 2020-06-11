#include "modelssingleton.h"
#include "scripts.h"

// memory leaks
#include <crtdbg.h>
#ifdef _DEBUG 
  #define new new( _CLIENT_BLOCK, __FILE__, __LINE__)
#endif // _DEBUG

ModelsSingleton* ModelsSingleton::_instance = NULL;

ModelsSingleton::ModelsSingleton(void)
{	
	_modelsCount = 0;
	
	_models.clear();
	
	_modelCube.InitModel( ".\\Resources\\cube.obj" , ".\\Resources\\diamond_ore.png" );

	_modelTorus.InitModel( ".\\Resources\\torus.obj" , ".\\Resources\\stonebrick_mossy.png" );

	_modelThing.InitModel( ".\\Resources\\untitled.obj" , ".\\Resources\\redstone_block.png" );

	_modelBook.InitModel( ".\\Resources\\LivreFerme.obj" , ".\\Resources\\LivreFermeRouge.png" );
	
	_modelCaterpie.InitModel( ".\\Resources\\chenipan.obj" , ".\\Resources\\chenipan.png" );

	_modelPokeball.InitModel( ".\\Resources\\pokeball.obj" , ".\\Resources\\pokeball.png" );

	_modelGround.InitModel( ".\\Resources\\ground.obj" , ".\\Resources\\ground.png" );

	_modelFond.InitModel( ".\\Resources\\fond.obj" , ".\\Resources\\ground.png" );

	_modelRock.InitModel( ".\\Resources\\rock.obj" , ".\\Resources\\stonebrick_mossy.png" );

	_modelFish.InitModel( ".\\Resources\\Magicarpe.obj" , ".\\Resources\\magicarpe_UV.png" );
}

ModelsSingleton::~ModelsSingleton(void)
{
	std::list<Model*>::iterator it = _models.begin();
	while (it != _models.end())
	{
		delete (*it);
		it = _models.erase(it);
	}
	std::map<Model*, float>::iterator it2 = _modelsToRemove.begin();
	while (it2 != _modelsToRemove.end())
	{
		it2 = _modelsToRemove.erase(it2);
	}
}

//////////////////////////
//  SINGLETON INSTANCE  //
//////////////////////////
ModelsSingleton* ModelsSingleton::Instance()
{
	if( _instance == NULL )
		_instance = new ModelsSingleton();
	return _instance;
}

void ModelsSingleton::ReleaseInstance()
{
	delete _instance;
	_instance = NULL;
}

//////////////////////////
//  INSTANTIATE/REMOVE  //
//////////////////////////
Model* ModelsSingleton::Instanciate(ModelName modelName)
{
	Model* model;

	switch(modelName)
	{

	case Torus:
		model = new Model(_modelTorus);
		break;

	case Book:
		model = new Model(_modelBook);
		break;

	case Thing:
		model = new Model(_modelThing);
		break;

	case Ground :
		model = new Model(_modelGround);
		break;

	case Caterpie :
		model = new Model(_modelCaterpie);
		break;

	case Pokeball :
		model = new Model(_modelPokeball);
		break;

	case Fond :
		model = new Model(_modelFond);
		break;

	case Rock :
		model = new Model(_modelRock);
		break;

	case Tree :
		model = new Model(_modelTree);
		break;

	case Fish :
		model = new Model(_modelFish);
		break;

	case Cube:
	default:
		model = new Model(_modelCube);
		break;

	}

	if( model == NULL )
		return NULL;

	model->_modelNum = _modelsCount;
	_models.push_back(model);

	_modelsCount++;

	return model;

}

Model* ModelsSingleton::Instanciate(ModelName modelName, Point3 position, Point3 rotation)
{
	Model* model = Instanciate(modelName);

	if( model == NULL )
		return NULL;

	model->SetLocation(position);
	model->SetRotation(rotation);

	return model;
}

void ModelsSingleton::Destroy(Model* model)
{
	_modelsToRemove[model] = 0.0f;
}

void ModelsSingleton::Destroy(Model* model, float timer)
{
	_modelsToRemove[model] = timer;
}

void ModelsSingleton::CleanListOfModels(UpdateArgs args)
{
	std::map<Model*, float>::iterator it = _modelsToRemove.begin();
	for( it; it != _modelsToRemove.end(); )
	{
		(*it).second -= args.GetDeltaTime();
		if( (*it).second <= 0.0f )
		{
			_models.remove((*it).first);
			delete (*it).first;
			it = _modelsToRemove.erase(it);
		}
		else
			it++;
		if( _modelsToRemove.empty() )
			return;
	}
}