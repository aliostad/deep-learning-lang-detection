#ifndef CHUNK_H
#define CHUNK_H
#include <GL/glut.h>
#include <math.h>
#include "block.h"
#include "Player.h"
#define CHUNK_SIZE 12
/*
 * No description
 */
class Chunk
{
	// private section
	public:
		// class constructor
		Chunk();
		// class destructor
		~Chunk();
		void RenderChunk(float x,float y,float z,GLuint a,Player Play);
		void Setup_Sphere();
		void Optimization(Player &Human);
	//protected:
		Block CnkDta[CHUNK_SIZE][CHUNK_SIZE][CHUNK_SIZE];
		float Height[CHUNK_SIZE][CHUNK_SIZE];
};

#endif // CHUNK_H

