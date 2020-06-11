#pragma once
#include "IChannelLocatorConnection.h"
class IChannelLocatorObserver;


class ChannelLocatorConnection : public IChannelLocatorConnection,
                                 public omni_thread
{
    enum EConnectionStatus{ CONNECTED, DISCONNECTED, RESTARTED };

public:

    ChannelLocatorConnection( const std::string& channel_locator_address );
    ~ChannelLocatorConnection();
    virtual void* run_undetached( void* );

    virtual std::string get_channel_locator_ior();
    virtual TA_Base_Core::IChannelLocator_var get_channel_locator();
    virtual CosNA::EventChannel_var get_channel( const std::string& name );
    virtual void register_observer( IChannelLocatorObserver* observer );
    virtual void deregister_observer( IChannelLocatorObserver* observer );

    void terminate();

public:

    void notify_observer( EConnectionStatus status );

public:

    volatile bool m_running;
    boost::log::sources::logger m_log;
    std::string m_channel_locator_address;
    std::string m_channel_locator_ior;
    TA_Base_Core::IChannelLocator_var m_channel_locator;
    std::string m_channel_locator_id;
    volatile EConnectionStatus m_connection_status;
    std::set<IChannelLocatorObserver*> m_observers;
    TA_Base_Core::ChannelMappingSeq_var m_channel_mapping;
    omni_mutex m_mutex;
    omni_condition m_condition;
};
