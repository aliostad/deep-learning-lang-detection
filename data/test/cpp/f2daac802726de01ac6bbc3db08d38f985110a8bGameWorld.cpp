#include "GameWorld.h"
#include "GameObject.h"
#include "DebugDraw.h"
void GameWorld::draw(RenderTarget& target, RenderStates states) const
{
	//draw the tiles
	for (auto chunk : Chunks)
	{
		target.draw(*chunk);
	}

	target.draw(*DebugDraw::GetInstance());
	DebugDraw::GetInstance()->clearArray();
}

void GameWorld::update(float DeltaTime)
{
	for (auto object : GameObjects)
	{
		object->update(DeltaTime);
	}
	
}

void GameWorld::createChunks(int sizex, int sizey)
{

	leftChunk = 0;
	topChunk = 0;
	botChunk = sizey-1;
	rightChunk = sizex - 1;

	for (int i = 0; i < sizex; i++)
	{
		for (int j = 0; j < sizey; j++)
		{
			Chunk *newChunk = new Chunk();			
			newChunk->load(i, j, true);
			//newChunk->generateTiles();
			Chunks.push_back(newChunk);
		}
	}

	TerrainCenter.x =( sizex*ChunkSize*TileSize)/2 ;
	TerrainCenter.y = (sizey*ChunkSize*TileSize) / 2;
}

Chunk* GameWorld::getChunk(Vector2f position)const
{
	Chunk * chosenchunk = nullptr;
	for (auto chunk : Chunks)
	{
		//y axis
		if (chunk->Top() < position.y && chunk->Bottom() > position.y)
		{
			// x axis
			if (chunk->Left() < position.x && chunk->Right() > position.x)
			{

				chosenchunk = chunk;
				return chosenchunk;
				break;
			}
		}
	}
	return chosenchunk;
}
Chunk* GameWorld::getChunkFromCoords(int x, int y)const
{
	Chunk * chosenchunk = nullptr;


	Vector2f position;
	position.x = x*ChunkSize*TileSize + 5;
	position.y = y*ChunkSize*TileSize + 5;

	chosenchunk = getChunk(position);

	return chosenchunk;
}


bool GameWorld::saveChunks()
{
	for (auto chunk : Chunks)
	{
		chunk->save();
	}
	return true;
}

void GameWorld::checkChunkBounds(Vector2f topleft, Vector2f botright)
{
	float left = leftChunk * TileSize*ChunkSize;
	float right = rightChunk + 1 * TileSize*ChunkSize;
	float bot = botChunk * TileSize*ChunkSize;
	float top = topChunk * TileSize*ChunkSize;
	Chunk * thechunk = nullptr;
	
	
	if (topleft.x < TerrainCenter.x - 2*TileSize*ChunkSize)
	{
		//move left
		bool moved = false;
		for (int i = topChunk; i <= botChunk; i++)
		{
			thechunk = getChunkFromCoords(rightChunk, i);
			if (thechunk)
			{
				thechunk->save();
				thechunk->clear();
				thechunk->load(leftChunk - 1, i, true);
				moved = true;
			}
		}
		if (moved)
		{
			leftChunk--;
			rightChunk--;
			TerrainCenter.x -= TileSize*ChunkSize;
		}

	}
	else if (botright.x > TerrainCenter.x + 2*TileSize*ChunkSize)
	{
		//move left
		bool moved = false;
		for (int i = topChunk; i <= botChunk; i++)
		{
			Vector2f position;
			position.x = leftChunk*ChunkSize*TileSize + 5;
			position.y = i*ChunkSize*TileSize + 5;

			thechunk = getChunk(position);


			//thechunk = getChunkFromCoords(leftChunk, i);
			if (thechunk)
			{
				thechunk->save();
				thechunk->clear();
				thechunk->load(rightChunk+  1, i, true);
				moved = true;
			}
		}
		if (moved)
		{
			leftChunk++;
			rightChunk++;
			TerrainCenter.x += TileSize*ChunkSize;
		}
	}


	//
	//
	//
	//
	//
	//
	//if (topleft.x < left)
	//{
	//	bool moved = false;
	//	for (int i = topChunk; i <= botChunk; i++)
	//	{
	//		thechunk = getChunkFromCoords(rightChunk, i);
	//		if (thechunk)
	//		{
	//			thechunk->save();
	//			thechunk->clear();
	//			thechunk->load(leftChunk-1, i);			
	//			moved = true;
	//		}
	//	}
	//	if (moved)
	//	{
	//		leftChunk--;
	//		rightChunk--;
	//	}
	//	
	//}
	////boundaries on the right
	//else if (botright.x > right)
	//{
	//	bool moved = false;
	//	for (int i = topChunk; i <= botChunk; i++)
	//	{
	//		thechunk = getChunkFromCoords(leftChunk, i);
	//		if (thechunk)
	//		{
	//			thechunk->save();
	//			thechunk->clear();
	//			thechunk->load(rightChunk+1, i);
	//			moved = true;
	//		}
	//	}
	//	if (moved)
	//	{
	//		leftChunk++;
	//		rightChunk++;
	//	}
	//}
}

