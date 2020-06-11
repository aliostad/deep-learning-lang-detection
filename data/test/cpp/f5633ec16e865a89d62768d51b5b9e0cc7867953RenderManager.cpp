#include "RenderManager.h"

CoreAPI *RenderManager::API = 0;
RENDERER RenderManager::TYPE;

void RenderManager::RunApplication()
{
	if(API)
	{
		API->Execute();
	}
}

void RenderManager::CreateApplication(RENDERER type)
{
	if(!API)
	{
		switch(type)
		{
			case RENDERER::OPENGL:
			{
				API = new GLCore();
				API->Init();
				TYPE = type;
			}
			break;

			default: break;
		}
	}
}

void RenderManager::DestroyApplication()
{
	if(API)
	{
		API->Shutdown();
		API = 0;
	}
}

 CoreAPI *RenderManager::_API() 
{
	switch(TYPE)
	{
		case RENDERER::OPENGL : return API;
		default: return 0;
	}
}