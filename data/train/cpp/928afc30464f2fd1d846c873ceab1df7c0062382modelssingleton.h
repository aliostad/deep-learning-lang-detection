#pragma once

#include "model.h"
#include <list>
#include <map>

////      ///////      ////
//	DECLARE MODELS ENUM  //
////      ///////      ////
enum ModelName
{
	Cube = 0,
	Torus,
	Book,
	Thing,
	Ground,
	Caterpie,
	Pokeball,
	Fond,
	Rock,
	Tree,
	Fish
};

class ModelsSingleton
{
public:
	static ModelsSingleton* Instance();
	static void ReleaseInstance();
	
	// add model to the render list
	Model* Instanciate(ModelName modelName);
	Model* Instanciate(ModelName modelName, Point3 position, Point3 rotation);
	// remove model from render list
	void Destroy(Model* model);
	void Destroy(Model* model, float timer);
	void CleanListOfModels(UpdateArgs args);

	std::list<Model*> _models;
	std::map<Model*, float> _modelsToRemove;

	// models count from beginning of the app
	int _modelsCount;

	Model _modelCube;
	Model _modelTorus;
	Model _modelThing;
	Model _modelBook;
	Model _modelCaterpie;
	Model _modelPokeball;
	Model _modelGround;
	Model _modelFond;
	Model _modelRock;
	Model _modelTree;
	Model _modelFish;

private:
	ModelsSingleton(void);
	~ModelsSingleton(void);

	static ModelsSingleton* _instance;


	
};

