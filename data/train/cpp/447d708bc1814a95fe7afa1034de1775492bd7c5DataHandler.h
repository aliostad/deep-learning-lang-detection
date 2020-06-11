#ifndef _DATAHANDLER_H
#define	_DATAHANDLER_H

class DataHandler : public virtual IPeerHandler {
public:
    DataHandler(PeerConnection *conn, IPeerEventHandler *handler) {
        this->conn = conn;
        this->handler = handler;
    }
    DataHandler(const DataHandler& orig) {
        throw Exception("suddenly DataHandler(&)");
    }
    virtual ~DataHandler() {
        
    }

    void handlePeerData(const std::string& data) {
        handler->onPeerData(conn, data);
    }

    void handlePeerCommand(const std::string& data) {
    }

private:

    PeerConnection *conn;
    IPeerEventHandler *handler;

};

#endif	/* _DATAHANDLER_H */

