#include "../managers/StateManager.h"
#include "LoadState.h"
#include "GameState.h"

void LoadState::init()
{
    m_pLoadList = new LoadList();

    m_pLoadList->addLoadItem(TAG_SURFACE, "./assets/png/Tileset1.png");
    m_pLoadList->addLoadItem(TAG_SURFACE, "./assets/png/Hero.png");
    m_pLoadList->addLoadItem(TAG_SPRITE, "./assets/sprites/wall.sprite");
    m_pLoadList->addLoadItem(TAG_SPRITE, "./assets/sprites/lockGate.sprite");
    m_pLoadList->addLoadItem(TAG_SPRITE, "./assets/sprites/tv.sprite");
    m_pLoadList->addLoadItem(TAG_SPRITE, "./assets/sprites/cooler.sprite");
    m_pLoadList->addLoadItem(TAG_SPRITE, "./assets/sprites/hero.sprite");
    m_pLoadList->addLoadItem(TAG_TILEMAP, "./assets/tilemaps/level1.tilemap");

    LoadManager::getInstance()->setLoadList(m_pLoadList);
}

void LoadState::destroy()
{
    delete m_pLoadList;
}

void LoadState::update(size_t dt)
{
    if (LoadManager::getInstance()->loadProcessing())
       StateManager::getInstance()->switchState(new GameState());
}

void LoadState::render()
{

}
