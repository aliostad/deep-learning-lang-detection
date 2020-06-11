/*
 * ModelManager.cpp
 *
 *  Created on: Jan 17, 2013
 *      Author: cws
 */

#include "ModelManager.h"

ModelManager::ModelManager() {
}

void ModelManager::addTimeUpdater(TimeUpdater* timeUpdater) {
	_timeUpdaters.push_back(timeUpdater);
}

void ModelManager::addTimeModel(TimeModel* timeModel) {
	_timeModels.push_back(timeModel);
}

void ModelManager::addChangeModel(TimeModel* timeModel,
		ChangeModel* changeModel) {
	_timeModelChangeModelMap[timeModel].push_back(changeModel);
}

void ModelManager::addUpdater(ChangeModel* changeModel, Updater* updater) {
	_changeModelChangeUpdaterMap[changeModel].push_back(updater);
}

std::vector<TimeModel*> * ModelManager::getTimeModels() {
	return &_timeModels;
}

std::vector<TimeUpdater*> * ModelManager::getTimeUpdater() {
	return &_timeUpdaters;
}

std::vector<ChangeModel*> * ModelManager::getChangeModels(TimeModel* timeModel) {
	// returns default value if lookup is not successful
	return &_timeModelChangeModelMap[timeModel];
}

std::vector<ChangeModel*> * ModelManager::getChangeModels(
		std::set<TimeModel*> timeModels) {

	std::vector<ChangeModel*> * changeModels = new std::vector<ChangeModel*>();

	std::set<TimeModel*>::iterator it = timeModels.begin();
	for ( ; it != timeModels.end(); ++it){
		std::vector<ChangeModel*> * res = getChangeModels(*it);
		changeModels->insert(changeModels->end(), res->begin(), res->end());
	}

	return changeModels;

}

std::vector<Updater*> * ModelManager::getUpdaters(ChangeModel* changeModel) {
	return &_changeModelChangeUpdaterMap[changeModel];
}

std::string ModelManager::getLatestMessage() {
	return " ";
}
