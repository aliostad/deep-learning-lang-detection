// Class header
#include <PacketChunkReceived.hpp>

// STL
#include <iostream>


PacketChunkReceived::PacketChunkReceived(int idFile, int numChunk) : Packet()
{
	setType (EChunkReceived);
	
	(*this) << idFile;
	(*this) << numChunk;
}

PacketChunkReceived::PacketChunkReceived(const Packet& p) : Packet(p)
{

}

PacketChunkReceived::~PacketChunkReceived()
{

}

int PacketChunkReceived::getIdFile ()
{
	setPosition (0);
	int id;
	(*this) >> id;
	return id;
}

int PacketChunkReceived::getChunkNumber ()
{
	setPosition (1);
	int num;
	(*this) >> num;
	return num;
}
