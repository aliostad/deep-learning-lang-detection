#include "pch.h"
#include "ServiceLocator.h"

using namespace Tungsten;

ServiceLocator Tungsten::Services;
ServiceLocator::ServiceLocator(void)
{
	graphics=NULL;
}





ServiceLocator::~ServiceLocator(void)
{
}

IGraphicsService* ServiceLocator::Graphics()
{	
	if(graphics) return graphics;
	return NULL;
}

void ServiceLocator::SetGraphics(IGraphicsService* graphics)
{
	this->graphics=graphics;
}

IConfigurationService* ServiceLocator::Config()
{
	if(config) return config;
	return NULL;
}

void ServiceLocator::SetConfig(IConfigurationService* config)
{
	this->config=config;
}

ISpriteTextService* ServiceLocator::SpriteText()
{
	return spriteText;
}

void ServiceLocator::Refresh()
{
	spriteText->Clear();
	input->Refresh();
	graphics->Refresh();
}

void ServiceLocator::SetSpriteText(ISpriteTextService* spriteText)
{
	this->spriteText=spriteText;
}

InputService* ServiceLocator::Input()
{
	return input;	
}

void ServiceLocator::SetInput(InputService* input)
{
	this->input=input;
}

IImporterService* ServiceLocator::Import()
{
	return importer;
}

void ServiceLocator::SetImporter(IImporterService* importer)
{
	this->importer = importer;
}