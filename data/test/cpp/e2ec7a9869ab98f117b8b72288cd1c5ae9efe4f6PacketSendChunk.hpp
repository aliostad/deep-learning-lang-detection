#ifndef PACKETSENDCHUNK_H
#define PACKETSENDCHUNK_H


/*
 * Classe PacketSendChunk
 *
 * Hérite de la classe Packet
 * Gérer un type de packet spécifique
 *
 *
 *
 *
 * par Olivier
 */


// Project header
#include <Packet.hpp>

// forward declaration
class Chunk;


class PacketSendChunk : public Packet
{
private:
	

public:
	/**
	* Création d'un PacketSendChunk pret à être envoyé
	* 
	*/
	PacketSendChunk(Chunk& chunk);
	
	/**
	* Constructeur sur un Packet (une maniere de caster un Packet)
	*/
	PacketSendChunk(const Packet& p);
	
	/**
	* Destructeur
	*/
	virtual ~PacketSendChunk();
	
	Chunk* getChunk ();

private:
	PacketSendChunk() {};

};

#endif // PACKETSENDCHUNK_H
