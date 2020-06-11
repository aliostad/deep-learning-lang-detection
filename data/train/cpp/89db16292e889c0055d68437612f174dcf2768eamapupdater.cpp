#include "mapupdater.h"

void MapUpdater::run()
{
	if(-xTrn > MAP_SIZE * cellSize * 0.5f)
	{
		xTrn += MAP_SIZE * cellSize;
		chunk[0] = chunk[1];
		chunk[3] = chunk[4];
		chunk[6] = chunk[7];
		chunk[1] = chunk[2];
		chunk[4] = chunk[5];
		chunk[7] = chunk[8];
		
		chunk[2].clear();
		chunk[2].setSide(Chunk::Left, chunk[1].heightMap);
		chunk[2].generate();
		
		chunk[5].clear();
		chunk[5].setSide(Chunk::Left, chunk[4].heightMap);
		chunk[5].setSide(Chunk::Bottom, chunk[2].heightMap);
		chunk[5].generate();
		
		chunk[8].clear();
		chunk[8].setSide(Chunk::Left, chunk[7].heightMap);
		chunk[8].setSide(Chunk::Bottom, chunk[5].heightMap);
		chunk[8].generate();
		
		glDeleteLists(chunkList[0], 9);
		
		updateDisplayLists();
	}
	if(-xTrn < -MAP_SIZE * cellSize * 0.5f)
	{
		xTrn -= MAP_SIZE * cellSize;
		chunk[2] = chunk[1];
		chunk[5] = chunk[4];
		chunk[8] = chunk[7];
		chunk[1] = chunk[0];
		chunk[4] = chunk[3];
		chunk[7] = chunk[6];
		
		chunk[0].clear();
		chunk[0].setSide(Chunk::Right, chunk[1].heightMap);
		chunk[0].generate();
		
		chunk[3].clear();
		chunk[3].setSide(Chunk::Right, chunk[4].heightMap);
		chunk[3].setSide(Chunk::Bottom, chunk[0].heightMap);
		chunk[3].generate();
		
		chunk[6].clear();
		chunk[6].setSide(Chunk::Right, chunk[7].heightMap);
		chunk[6].setSide(Chunk::Bottom, chunk[3].heightMap);
		chunk[6].generate();
		
		glDeleteLists(chunkList[0], 9);
		
		updateDisplayLists();
	}
	if(-zTrn > MAP_SIZE * cellSize * 0.5f)
	{
		zTrn += MAP_SIZE * cellSize;
		chunk[0] = chunk[3];
		chunk[1] = chunk[4];
		chunk[2] = chunk[5];
		chunk[3] = chunk[6];
		chunk[4] = chunk[7];
		chunk[5] = chunk[8];
		
		chunk[6].clear();
		chunk[6].setSide(Chunk::Bottom, chunk[3].heightMap);
		chunk[6].generate();
		
		chunk[7].clear();
		chunk[7].setSide(Chunk::Left, chunk[6].heightMap);
		chunk[7].setSide(Chunk::Bottom, chunk[4].heightMap);
		chunk[7].generate();
		
		chunk[8].clear();
		chunk[8].setSide(Chunk::Left, chunk[7].heightMap);
		chunk[8].setSide(Chunk::Bottom, chunk[5].heightMap);
		chunk[8].generate();
		
		glDeleteLists(chunkList[0], 9);
		
		updateDisplayLists();
	}
	if(-zTrn < -MAP_SIZE * cellSize * 0.5f)
	{
		zTrn -= MAP_SIZE * cellSize;
		chunk[6] = chunk[3];
		chunk[7] = chunk[4];
		chunk[8] = chunk[5];
		chunk[3] = chunk[0];
		chunk[4] = chunk[1];
		chunk[5] = chunk[2];
		
		chunk[0].clear();
		chunk[0].setSide(Chunk::Top, chunk[3].heightMap);
		chunk[0].generate();
		
		chunk[1].clear();
		chunk[1].setSide(Chunk::Top, chunk[4].heightMap);
		chunk[1].setSide(Chunk::Left, chunk[0].heightMap);
		chunk[1].generate();
		
		chunk[2].clear();
		chunk[2].setSide(Chunk::Top, chunk[5].heightMap);
		chunk[2].setSide(Chunk::Left, chunk[1].heightMap);
		chunk[2].generate();
		
		glDeleteLists(chunkList[0], 9);
		
		updateDisplayLists();
	}
}

void MapUpdater::updateDisplayLists()
{
	GLfloat deltaTextureSize;
	GLfloat textureX;
	GLfloat textureY;
	GLfloat mapX;
	GLfloat mapZ;
	chunkList[0] = glGenLists(9);
	for(int i = 0; i < 9; ++i)
	{
		chunkList[i] = (i > 0) ? chunkList[i - 1] + 1 : chunkList[0];
		glNewList(chunkList[i], GL_COMPILE);
	
		glBindTexture(GL_TEXTURE_2D, grassTexture);
		
		deltaTextureSize = 1.0f / MAP_SIZE;
		textureX = 0.0f;
		textureY = 0.0f;
		mapX = -MAP_SIZE / 2 * cellSize;
		mapZ = -MAP_SIZE / 2 * cellSize;
		for(int j = 0; j < MAP_SIZE - 1; ++j)
		{
			glBegin(GL_TRIANGLE_STRIP);
			
			for(int k = 0; k < MAP_SIZE; ++k)
			{
				// First triangle
				glTexCoord2f(textureX + deltaTextureSize, textureY);
				glVertex3f(mapX + cellSize, chunk[i].heightMap[j + 1][k], mapZ);
				
				// Second triangle
				glTexCoord2f(textureX, textureY);
				glVertex3f(mapX, chunk[i].heightMap[j][k], mapZ);
				
				mapZ += cellSize;
				textureY += deltaTextureSize;
			}
			glEnd();
			textureX += deltaTextureSize;
			mapX += cellSize;
			mapZ = -MAP_SIZE / 2 * cellSize;
			textureY = 0.0f;
		}
		glEndList();
	}
}