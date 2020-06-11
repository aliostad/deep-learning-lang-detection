#include <Datagram.h>
#include <Server.h>
#include <Instruction.h>
#include <mutex>
#include <list>

class ServerLoadSend : public Datagram<ServerLoadSend> {
public:
	ServerLoadSend(): Datagram<ServerLoadSend>("ServerLoadSend")  {};
};

class ServerLoadRcvd : public Datagram<ServerLoadRcvd> {
	int idServer;
	int idZone;
	double zoneLoad;
	int remainingZones;
	public:
	ServerLoadRcvd() : Datagram<ServerLoadRcvd>("ServerLoadRcvd") {}
	virtual ~ServerLoadRcvd();
	void exec(Connection*) const throw();
};
