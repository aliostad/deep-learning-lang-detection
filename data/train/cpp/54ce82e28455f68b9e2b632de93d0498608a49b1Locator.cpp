#include "Locator.h"


// this must be in a .cpp file =(
std::shared_ptr<Renderer> Locator::renderer = nullptr;
std::shared_ptr<ActorManager> Locator::actorManager = nullptr;


void Locator::provideRenderer(std::shared_ptr<Renderer> service)
{
	renderer = service;
}

void Locator::provideActorManager(std::shared_ptr<ActorManager> service)
{
	actorManager = service;
}

std::shared_ptr<Renderer> Locator::getRenderer()
{
	return renderer;
}

std::shared_ptr<ActorManager> Locator::getActorManager()
{
	return actorManager;
}