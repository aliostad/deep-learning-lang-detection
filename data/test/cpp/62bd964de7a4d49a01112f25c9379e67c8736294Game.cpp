
#include "Game.h"
#include "Global.h"
#include "Menu/TitleScreen.h"
#include "Load/InitialLoadListener.h"

namespace SmashBros
{
	Game::Game()
	{
		smashData = nullptr;
		menuLoad = nullptr;
		moduleLoad = nullptr;
		menuScreenMgr = nullptr;
		titleScreen = nullptr;
		Graphics::setDefaultFontPath("assets/fonts/arial.ttf");
	}
	
	Game::~Game()
	{
		if(menuScreenMgr != nullptr)
		{
			delete menuScreenMgr;
		}
		if(titleScreen != nullptr)
		{
			delete titleScreen;
		}
		if(smashData != nullptr)
		{
			delete smashData;
		}
		if(menuLoad != nullptr)
		{
			delete menuLoad;
		}
		if(moduleLoad != nullptr)
		{
			delete moduleLoad;
		}
	}
	
	void Game::initialize()
	{
		#ifdef TARGETPLATFORMTYPE_DESKTOP
			getWindow()->setSize(Vector2u(SMASHBROS_WINDOWWIDTH, SMASHBROS_WINDOWHEIGHT));
		#endif
		Vector2u windowSize = getWindow()->getSize();
		getWindow()->getView()->setSize(windowSize.x, windowSize.y);
		setFPS(60);
		menuLoad = new MenuLoad(*getWindow(), "assets/menu");
		moduleLoad = new ModuleLoad(*getWindow(), "assets/characters", "assets/stages");
		smashData = new SmashData(getWindow(), menuLoad, moduleLoad);
	}
	
	void Game::loadContent(AssetManager*assetManager)
	{
		InitialLoadListener* loadListener = new InitialLoadListener(getWindow());
		menuLoad->setLoadListener(loadListener);
		
		menuLoad->load();
		
		moduleLoad->setCharacterSelectIconMask(&menuLoad->getCharacterSelectIconMask());
		moduleLoad->setStageSelectIconMask(&menuLoad->getStageSelectIconMask());
		moduleLoad->setStageSelectPreviewMask(&menuLoad->getStageSelectPreviewMask());
		moduleLoad->load();
		
		delete loadListener;

		titleScreen = new Menu::TitleScreen(*smashData);
		menuScreenMgr = new ScreenManager(getWindow(), titleScreen);
	}
	
	void Game::unloadContent(AssetManager*assetManager)
	{
		moduleLoad->unload();
		menuLoad->unload();
	}
	
	void Game::update(ApplicationData appData)
	{
		appData.setAssetManager(menuLoad->getAssetManager());
		menuScreenMgr->update(appData);
	}
	
	void Game::draw(ApplicationData appData, Graphics graphics) const
	{
		appData.setAssetManager(menuLoad->getAssetManager());
		menuScreenMgr->draw(appData, graphics);
	}
}
