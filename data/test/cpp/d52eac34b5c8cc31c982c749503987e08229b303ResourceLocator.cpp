#include "ResourceLocator.h"

ResourceLocator* ResourceLocator::instance;
ResourceLocator* ResourceLocator::get() {
	if (instance == nullptr) {
		instance = new ResourceLocator();
	}

	return instance;
}

ResourceLocator::ResourceLocator() {}


void ResourceLocator::setGraphics(IGraphics* graphics) {
	this->graphics = graphics;
}
IGraphics* ResourceLocator::getGraphics() {
	return graphics;
}


void ResourceLocator::setLog(ILog* log) {
	this->log = (log == nullptr) ? this->NULL_LOG : log;
}
ILog* ResourceLocator::getLog() {
	return log;
}


void ResourceLocator::setManager(IManager* manager) {
	this->manager = manager;
}
IManager* ResourceLocator::getManager() {
	return manager;
}