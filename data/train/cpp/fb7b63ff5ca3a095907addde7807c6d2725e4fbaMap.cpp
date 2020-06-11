#include "Map.h"
#include "Chunk.h"
#include <random>

Map::Map() :
	Height(18), Width(32) {
}

Map::~Map() {

}

void Map::SetUp(int seed) {
	
	Chunk* tempChunk = new Chunk(0,32,18,true);

	tempChunk->GenerateData(seed);

	Chunks.push_back(tempChunk);

	CurrentChunk = tempChunk;

	Chunk* tempChunk2 = new Chunk(-1, 32, 18, true);

	tempChunk2->GenerateData(seed);

	Chunks.push_back(tempChunk2);

	FirstChunk = tempChunk2;

	Chunk* tempChunk3 = new Chunk(1, 32, 18, true);

	tempChunk3->GenerateData(seed);

	Chunks.push_back(tempChunk3);

	LastChunk = tempChunk3;


}

void Map::CheckPosition(int position, Player* player, int seed) {

	if ((player->xPos + player->Position*15.5f) >= (15.5f*(player->Position+1))) {

		player->Position += 1;
		Chunk* temp = CurrentChunk;
		CurrentChunk = LastChunk;
		FirstChunk = temp;


		LastChunk = new Chunk(1, 32, 18, true);
		LastChunk->GenerateData(seed);
		Chunks.push_back(LastChunk);

	}
	else if ((player->xPos + player->Position*15.5f) <= (15.5f*(player->Position))) {

		player->Position -= 1;
		
		Chunk* temp = CurrentChunk;
		CurrentChunk = FirstChunk;
		LastChunk = temp;


		FirstChunk = new Chunk(1, 32, 18, true);
		FirstChunk->GenerateData(seed);
		Chunks.push_back(LastChunk);

	}

}

void Map::CreateChunk(int direction, int seed) {

	if (direction < 1) {
		// Create Left Chunk

		Chunk* NewChunk = new Chunk(FirstChunk->Position - 1, 32, 18, false);
		NewChunk->GenerateData(seed);
		Chunks.push_back(NewChunk);

		delete NewChunk;

	}
	else if (direction >= 1) {
		// Create Right Chunk

		Chunk* NewChunk = new Chunk(LastChunk->Position + 1, 32, 18, false);
		NewChunk->GenerateData(seed);
		Chunks.push_back(NewChunk);

		delete NewChunk;

	}

}