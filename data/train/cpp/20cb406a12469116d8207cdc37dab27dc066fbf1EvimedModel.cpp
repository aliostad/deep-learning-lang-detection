/*
 * EvimedModel.cpp
 *
 *  Created on: Feb 13, 2013
 *      Author: indra
 */

#include "EvimedModel.h"

namespace model {


EvimedModel::EvimedModel() {
	// TODO Auto-generated constructor stub
}

EvimedModel::EvimedModel(map<string, string> data) {
	this->mapModel = data;
}

void EvimedModel::put(string key, string value){
	mapModel.insert(pair<string, string>(key, value));
}

void EvimedModel::put(string key, EvimedModel model){

	mapModel.insert(pair<string, string>(key, model.toString()));
}

string EvimedModel::get(string key){
	return string(mapModel.find(key)->second);
}

void EvimedModel::remove(string key){
	mapModel.erase(key);
}

void EvimedModel::update(string key, string value){
	const_cast<string &>(mapModel.find(key)->second) = value;
}

string EvimedModel::toString(){
	return JSONUtil::createJSONString(mapModel);
}

map<string, string> EvimedModel::getMap(){
	return mapModel;
}

EvimedModel::~EvimedModel() {
	// TODO Auto-generated destructor stub
}

} /* namespace model */
