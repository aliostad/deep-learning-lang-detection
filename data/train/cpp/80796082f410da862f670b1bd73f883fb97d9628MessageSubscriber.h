#pragma once
#include "Consumer.h"
#include "IChannelLocatorObserver.h"
class IChannelLocatorConnection;


class MessageSubscriber : public Consumer,
                          public IChannelLocatorObserver
{
public:

    MessageSubscriber( const std::string& channel_locator_address, const std::string& channel_name );
    ~MessageSubscriber();

    virtual void connection_connected();
    virtual void connection_disconnected();
    virtual void connection_restarted();

public:

    std::string m_channel_locator_address;
    std::string m_channel_name;
    IChannelLocatorConnection* m_connection;
};
