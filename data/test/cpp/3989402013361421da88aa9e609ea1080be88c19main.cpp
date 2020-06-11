#include "Server.h"
#include "TcpHandler.h"
#include "UdpHandler.h"
#include "PacketHandler.h"

#include <SFML/System.hpp>

void acceptNewClients(TcpHandler* tcp)
{
	while(true) 
	{
		tcp->acceptConnections();
		Sleep(10);
	}
}

int main()
{	
	TcpHandler* tcpHandler = new TcpHandler();
	UdpHandler* udpHandler = new UdpHandler();

	PacketHandler* packetHandler = new PacketHandler(udpHandler, tcpHandler);

	Server* server = new Server(packetHandler);

	packetHandler->attach(server);

	sf::Thread acceptThread(&acceptNewClients, tcpHandler);

	sf::TcpSocket* dcPlayer;

	acceptThread.launch();

	while(true)
	{
		dcPlayer = tcpHandler->keepSocketsAlive();
		if(dcPlayer != NULL)
			server->handlePlayerDisconnect(dcPlayer);

		packetHandler->receiveData();
		server->run();

		Sleep(5);
	}

	return 0;
}