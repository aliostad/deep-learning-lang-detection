#include "ChunkManager.hpp"


ChunkManager::ChunkManager()
{

}


ChunkManager::~ChunkManager()
{

}

void ChunkManager::Update(const UpdateData & updateobject)
{
	Chunk * c = FirstChunk;
	bool GoingRight = true;
	while (c != NULL)
	{
		c->Update(updateobject);
		if (GoingRight && c->getRight() != NULL)
		{
			c = c->getRight();
		}
		else if (!GoingRight && c->getLeft() != NULL)
		{
			c = c->getLeft();
		}
		else
		{
			c = c->getBottom();
			GoingRight = !GoingRight;
		}
	}
	sf::Vector2f v = WindowManager::getInstance().getCameraPosition();
	while (v.x < ActiveChunk->getPurePosition().x
		|| v.y < ActiveChunk->getPurePosition().y
		|| v.x >= ActiveChunk->getPurePosition().x + ActiveChunk->getSize()
		|| v.y >= ActiveChunk->getPurePosition().y + ActiveChunk->getSize())
	{
		if (v.x < ActiveChunk->getPurePosition().x)
		{
			if (ActiveChunk->getLeft() != nullptr)
				ActiveChunk = ActiveChunk->getLeft();
			else
				WindowManager::getInstance().setCameraPosition(sf::Vector2f{ ActiveChunk->getPurePosition().x, WindowManager::getInstance().getCameraPosition().y });
		}
		else if (v.y < ActiveChunk->getPurePosition().y)
		{
			if (ActiveChunk->getTop() != nullptr)
				ActiveChunk = ActiveChunk->getTop();
			else
				WindowManager::getInstance().setCameraPosition(sf::Vector2f{ WindowManager::getInstance().getCameraPosition().x, ActiveChunk->getPurePosition().y });
		}
		else if (v.x > ActiveChunk->getPurePosition().x + ActiveChunk->getSize())
		{
			if (ActiveChunk->getRight() != nullptr)
				ActiveChunk = ActiveChunk->getRight();
			else
				WindowManager::getInstance().setCameraPosition(sf::Vector2f{ ActiveChunk->getPurePosition().x + ActiveChunk->getSize(), WindowManager::getInstance().getCameraPosition().y });

		}
		else if (v.y > ActiveChunk->getPurePosition().y + ActiveChunk->getSize())
		{
			if (ActiveChunk->getBottom() != nullptr)
				ActiveChunk = ActiveChunk->getBottom();
			else
				WindowManager::getInstance().setCameraPosition(sf::Vector2f{ WindowManager::getInstance().getCameraPosition().x, ActiveChunk->getPurePosition().y + ActiveChunk->getSize() });
		}
	}
}

void ChunkManager::Draw(sf::RenderWindow & window, sf::Vector2f offset)
{
	ActiveChunk->Draw(window, offset);
}


void ChunkManager::setActiveChunk(Chunk * c)
{
	ActiveChunk = c;
}

void ChunkManager::setFirstChunk(Chunk * c)
{
	FirstChunk = c;
	ActiveChunk = c;
}

void ChunkManager::addGameComponent(GameComponent * c)
{
	FirstChunk->addComponent(c);
}