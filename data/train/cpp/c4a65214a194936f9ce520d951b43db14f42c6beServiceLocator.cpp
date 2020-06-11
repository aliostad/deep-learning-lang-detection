#include "../includes/ServiceLocator.h"

Graphics*	ServiceLocator::graphicsService;
Input*		ServiceLocator::inputService;
Audio*		ServiceLocator::audioService;

ServiceLocator::ServiceLocator() {
}

ServiceLocator::~ServiceLocator() {
}

void ServiceLocator::provideAudio( Audio* service ) {
	audioService = service;
}

void ServiceLocator::provideGraphics( Graphics* service ) {
	graphicsService = service;
}

void ServiceLocator::provideInput( Input* service ) {
	inputService = service;
}

Graphics& ServiceLocator::getGraphics() {
	return *graphicsService;
}

Audio& ServiceLocator::getAudio() {
	return *audioService;
}

Input& ServiceLocator::getInput() {
	return *inputService;
}
