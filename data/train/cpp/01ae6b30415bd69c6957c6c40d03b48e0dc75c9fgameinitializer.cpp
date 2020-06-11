#include "gameinitializer.h"
#include "loadingsystem.h"
#include "inputsystem.h"
#include "menuactionsystem.h"
#include "rendersystem.h"
#include "physicssystem.h"
#include "collisionsystem.h"
#include "scoresystem.h"

Repository* GameInitializer::initializeRepository()
{
	Repository *repo = new Repository();
	return repo;
}

sf::RenderWindow* GameInitializer::initializerWindow()
{
	sf::RenderWindow *window = new sf::RenderWindow(sf::VideoMode(800, 600), "Bist Gaim evrr");
	sf::Vector2u windowSize = window->getSize();
    window->setVerticalSyncEnabled(true);
	return window;
}

std::list<System*> GameInitializer::initializeGameSystems(sf::RenderWindow *window, Repository *repo)
{
	std::list<System*> systemList;

	LoadingSystem *loadingSystem = new LoadingSystem(repo);
	systemList.push_back(loadingSystem);

	InputSystem *inputSystem = new InputSystem(repo);
	systemList.push_back(inputSystem);

	MenuActionSystem *menuActionSystem = new MenuActionSystem(repo);
	systemList.push_back(menuActionSystem);

	PhysicsSystem *physicsSystem = new PhysicsSystem(repo);
	systemList.push_back(physicsSystem);

	CollisionSystem *collisionSystem = new CollisionSystem(repo);
	systemList.push_back(collisionSystem);

	ScoreSystem *scoresystem = new ScoreSystem(repo);
	systemList.push_back(scoresystem);

	RenderSystem *renderSystem = new RenderSystem(repo, window);
	systemList.push_back(renderSystem);



	//Group creation
	repo->newGroup(GRP_GAMESTATE, ATTR_GAMESTATE);
	repo->newGroup(GRP_PLAYERS, ATTR_POSITION, ATTR_VELOCITY, ATTR_PLAYERSTATE, ATTR_KEYMAP);
	repo->newGroup(GRP_SWORDS, ATTR_POSITION, ATTR_VELOCITY, ATTR_SWORDSTATE);
	repo->newGroup(GRP_MENU, ATTR_TEXT, ATTR_SELECTION);
	repo->newGroup(GRP_MENUACTION, ATTR_MENUACTION);
	repo->newGroup(GRP_MENUSCORE, ATTR_MENUSCORE, ATTR_TEXT);
	repo->newGroup(GRP_PHYSICS, ATTR_POSITION, ATTR_VELOCITY, ATTR_GRAVITY);
	repo->newGroup(GRP_RENDERSPRITE, ATTR_SPRITE, ATTR_POSITION, ATTR_RECTANGLE);
	repo->newGroup(GRP_RENDERTEXT, ATTR_TEXT);
	repo->newGroup(GRP_MENUTEXT, ATTR_TEXT, ATTR_SELECTION);
	repo->newGroup(GRP_PLATFORM, ATTR_POSITION,ATTR_RECTANGLE,ATTR_STATIC);
	repo->newGroup(GRP_GAMEUTIL, ATTR_POSITION,ATTR_ROUNDSTATE);

	//Initial Game State Object for the Loading System
	repo->newGameStateObject(false, true, loadingSystem);

	return systemList;
}