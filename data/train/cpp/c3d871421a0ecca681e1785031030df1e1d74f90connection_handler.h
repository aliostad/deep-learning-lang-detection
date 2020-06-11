
#ifndef CONNECTION_HANDLER_H
#define	CONNECTION_HANDLER_H
#include<unistd.h>
#include <sys/socket.h>
#include <netdb.h> 
#include "mouse_handler.h"

class connection_handler {
public:

    connection_handler();
    connection_handler(const connection_handler& orig);
    virtual ~connection_handler();
    void connect();
    void disconnect();
private:
    struct addrinfo host_info;
    struct addrinfo *host_info_list;
    int socketfd;
    int new_sd;
    int status;
    mouse_handler m_handler;
};

#endif	/* CONNECTION_HANDLER_H */

