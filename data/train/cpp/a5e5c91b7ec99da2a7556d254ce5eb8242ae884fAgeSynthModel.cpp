#include "AgeSynthModel.h"


AgeSynthModel::AgeSynthModel(string path) : Model(path)
{
	cout << "Loading male age synth model" << endl;
	male = GenderModel(path+"\\male");
	cout << "Loading female age synth model" << endl;
	female = GenderModel(path+"\\female");
}

AgeSynthModel::AgeSynthModel(void)
{
}

AgeSynthModel::~AgeSynthModel(void)
{
}

// Getters
AgeSynthModel::GenderModel AgeSynthModel::getMale()
{
	return male;
}

AgeSynthModel::GenderModel AgeSynthModel::getFemale()
{
	return female;
}

// GenderModel functions
#pragma region

AgeSynthModel::GenderModel::GenderModel(void)
{
}

AgeSynthModel::GenderModel::GenderModel(string path)
{
	// Load the older/younger models
	cout << "Loading older gender model" << endl;
	older = Model(path+"\\older");
	cout << "Loading younger gender model" << endl;
	younger = Model(path+"\\younger");
}

Model AgeSynthModel::GenderModel::getYounger()
{
	return younger;
}
Model AgeSynthModel::GenderModel::getOlder()
{
	return older;
}
#pragma endregion