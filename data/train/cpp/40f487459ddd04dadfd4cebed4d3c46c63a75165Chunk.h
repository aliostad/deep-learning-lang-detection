/*
 *==========================================================================
 *       Filename:  Chunk.h
 *    Description:  
 *        Version:  1.0
 *        Created:  2014年07月09日 19时35分04秒
 *       Revision:  none
 *       Compiler:  g++
 *         Author:  chzwei, chzwei3@gmail.com
 *   Organization:  sysu
 *==========================================================================
 */
#ifndef CHUNK_H
#define CHUNK_H

class Chunk{
public:
	virtual int Send() = 0;
private:
};

class MemoryChunk : public Chunk{
public:
	char mem[1024];
	off_t offest;
	int Send(){

	}
private:
};

class FileChunk : public Chunk{
public:
	char *name;
	off_t start;
	off_t length;
	int fd;
	int Send(){
		ssize_t r;
		off_t tosend = length - 
	}
private:
};

#endif

