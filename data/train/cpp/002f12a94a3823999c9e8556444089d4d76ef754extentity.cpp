#include "extentity.h"


namespace Extentities
{
	ObjectGenerator<Extentity> generator;
	HandlerFactory<EntityHandler, int> handler;

	void RegisterStdHandler()
	{
		puts("init: register Extentities");
		handler.Register<EntityHandler>(NOTUSED);
		handler.Register<EntityHandlerLight>(LIGHT);
		handler.Register<EntityHandlerMapmodel>(MAPMODEL);
		handler.Register<EntityHandlerPlayerstart>(PLAYERSTART);
		handler.Register<EntityHandlerEnvmap>(ENVMAP);
		handler.Register<EntityHandlerParticles>(PARTICLES);
		handler.Register<EntityHandlerMapsound>(MAPSOUND);
		handler.Register<EntityHandlerSpotlight>(SPOTLIGHT);
		handler.Register<EntityHandlerTeleport>(TELEPORT);
		handler.Register<EntityHandlerTeledest>(TELEDEST);
		handler.Register<EntityHandlerMonster>(MONSTER);
		handler.Register<EntityHandlerJumppad>(JUMPPAD);
		handler.Register<EntityHandlerBox>(BOX);
		handler.Register<EntityHandlerBarrel>(BARREL);
		handler.Register<EntityHandlerPlatform>(PLATFORM);
		handler.Register<EntityHandlerElevator>(ELEVATOR);
		handler.Register<EntityHandlerWaypoint>(WAYPOINT);
		handler.Register<EntityHandlerCamera>(CAMERA);
		handler.Register<EntityHandlerDynlight>(DYNLIGHT);
		handler.Register<EntityHandlerGeneric>(GENERIC);
	}

	extentity *NewEntity()
	{
//		return new Extentities::Extentity();
		return generator.New();
	}

	void DeleteEntity(extentity *e)
	{
		delete (Extentities::Extentity *)e;
	}

	HandlerFactory<EntityHandler, int>& Handler()
	{
		return handler;
	}

	ObjectGenerator<Extentity>& Generator()
	{
		return generator;
	}

	void Destroy()
	{
		return;
	}
}
