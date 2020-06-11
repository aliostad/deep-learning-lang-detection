#ifndef LLJZ_DISK_HANDLER_ROUTER_H
#define LLJZ_DISK_HANDLER_ROUTER_H

/*
#include "tbsys.h"
#include "tbnet.h"
#include "request_packet.hpp"
#include "response_packet.hpp"
*/

namespace lljz {
namespace disk {

typedef void (*Handler)(RequestPacket* req,
    void* args,
    ResponsePacket* resp);

typedef __gnu_cxx::hash_map<uint32_t,Handler>
    HandlerMap;

#define HANDLER_ROUTER lljz::disk::HandlerRouter::GetHandlerRouter()

class HandlerRouter {
public:
    HandlerRouter();
    ~HandlerRouter();

    bool RegisterHandler(uint32_t msg_id, Handler handler);
    Handler GetHandler(uint32_t msg_id);

    static HandlerRouter& GetHandlerRouter();
private:
    HandlerMap handler_map_;
};

}
}

#endif