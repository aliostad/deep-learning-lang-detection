#ifndef _Server_h
#define _Server_h

#include <vector>
#include <Connection.h>
#include <ZoneLoad.h>
#include <iostream>

class Server {
	public:
	
	struct serverLoad {
		std::vector<ZoneLoad*> distribution;
		double totalLoad;
	};  
	int id;
	char* ip;
	char* port;
	Connection* c;
	serverLoad load;
	bool operator < (const Server & s) const
	{
		return (load.totalLoad < s.load.totalLoad);
	}


	Server(int idServer, char* ipServer, char* portServer): id(idServer), ip(ipServer), port(portServer) {} 	
	Server(){}
	virtual ~Server();
	void printServer();
};


#endif
