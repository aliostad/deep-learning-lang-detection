#ifndef __T4__ServerHandler__
#define __T4__ServerHandler__

#include "MsgQueue.hpp"

class ServerHandler;

typedef void (ServerHandler::*ServerHandlerFptr)(QueueMsg *m);

//处理服务器消息接口
class ServerHandler
{

public:
    ServerHandler(){}
    virtual ~ServerHandler(){}

    //根据事件类型返回handler。
    virtual ServerHandlerFptr FindHandler(int t) = 0;
    virtual void CallHandler(ServerHandlerFptr fptr, QueueMsg *m) = 0;

    //不断的从服务器消息队列中获取消息.
    //使用FindHandler的返回值进行处理。
    void Loop();

};

#endif
