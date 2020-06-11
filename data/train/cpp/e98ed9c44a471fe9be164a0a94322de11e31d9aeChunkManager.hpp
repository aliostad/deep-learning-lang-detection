#pragma once

#include "Chunk.hpp"
#include "GameComponent.hpp"
#include "Drawable.hpp"

class Chunk;

class ChunkManager
{
public:
	__declspec(dllexport) ChunkManager();
	__declspec(dllexport) ~ChunkManager();
	__declspec(dllexport) void Update(const UpdateData & updateobject);
	__declspec(dllexport) void Draw(sf::RenderWindow & window, sf::Vector2f offset);
	__declspec(dllexport) void setActiveChunk(Chunk * c);
	__declspec(dllexport) void setFirstChunk(Chunk * c);
	__declspec(dllexport) void addGameComponent(GameComponent * c);

private:
	Chunk * ActiveChunk;
	Chunk * FirstChunk;
};

