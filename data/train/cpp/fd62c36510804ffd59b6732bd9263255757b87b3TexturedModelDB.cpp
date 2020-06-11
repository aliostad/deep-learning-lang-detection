#include "../includes/TexturedModelDB.h"


using namespace std;

TexturedModelDB *TexturedModelDB::reference = 0;



TexturedModelDB::TexturedModelDB()
{
	model_array = new vector<MasterObject>();

}


TexturedModelDB::~TexturedModelDB()
{
	delete model_array;
	delete reference;
}



void TexturedModelDB::addModel(MasterObject &model) {

	for (vector<MasterObject>::iterator it = model_array->begin(); it!=model_array->end(); it++) {
		if (model.getName().compare((*it).getName()))
			return; 
	}
	model_array->push_back(model);

}
