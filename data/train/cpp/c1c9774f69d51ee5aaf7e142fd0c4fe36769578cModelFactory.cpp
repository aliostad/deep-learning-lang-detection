#include "ModelFactory.h"

namespace XOR {

ModelFactory * ModelFactory::_modelFactory = 0;

/*
 * private default constructor
 */
ModelFactory::ModelFactory() {
}

/*
 * singleton accessor
 */
ModelFactory * ModelFactory::GetInstance() {
	if (_modelFactory == NULL)
		_modelFactory = new ModelFactory();

	return _modelFactory;
}

/*
 * creates and returns a model
 */
Model * ModelFactory::createModel(char * pathToFile) {
	Model * temp = models[pathToFile];

	if (temp == NULL) {

		string path(pathToFile);
		string ext = path.substr(path.length() - 4);

		if (ext.compare("ms3d") == 0) {
			temp = new MilkshapeModel(pathToFile);
		} else {
			temp = NULL;
		}

		//put the model into the map, using the path as the key
		models[pathToFile] = temp;
	}

	return temp;
}

}

