#pragma once

#include "Locator.h"

IWorldManager* Locator::WorldManager()
{
	return m_pWorldManager;
}

void Locator::Provide(IWorldManager *pWorldManager)
{
	m_pWorldManager = pWorldManager;
}

IWorldSimulator* Locator::WorldSimulator()
{
	return m_pWorldSimulator;
}

void Locator::Provide(IWorldSimulator* pWorldSimulator)
{
	m_pWorldSimulator = pWorldSimulator;
}

IGameState* Locator::GameState()
{
	return m_pGameState;
}

void Locator::Provide(IGameState* pGameState)
{
	m_pGameState = pGameState;
}

IInputManager* Locator::InputManager()
{
	return m_pInputManager;
}

void Locator::Provide(IInputManager *pInputManager)
{
	m_pInputManager = pInputManager;
}

IFactoryManifest* Locator::FactoryManifest()
{
	return m_pFactoryManifest;
}

void Locator::Provide(IFactoryManifest *pFactoryManifest)
{
	m_pFactoryManifest = pFactoryManifest;
}

IDrawing* Locator::Drawing()
{
	return m_pDrawing;
}

void Locator::Provide(IDrawing *pDrawing)
{
	m_pDrawing = pDrawing;
}

IWorldManager* Locator::m_pWorldManager = nullptr;
IWorldSimulator* Locator::m_pWorldSimulator = nullptr;
IGameState* Locator::m_pGameState = nullptr;
IInputManager* Locator::m_pInputManager = nullptr;
IFactoryManifest* Locator::m_pFactoryManifest = nullptr;
IDrawing* Locator::m_pDrawing = nullptr;