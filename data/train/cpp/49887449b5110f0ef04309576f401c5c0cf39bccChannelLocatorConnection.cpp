#include "stdafx.h"
#include "ChannelLocatorConnection.h"
#include "IChannelLocatorObserver.h"
#include "Library/Corba.h"
#include "Library/Notify.h"


static const int RESOLUTION_FAILURE_DELAY_MS = 1;
static const int RESOLUTION_SUCCESS_DELAY_MS = 2;


ChannelLocatorConnection::ChannelLocatorConnection( const std::string& channel_locator_address )
    : omni_thread( NULL, omni_thread::PRIORITY_NORMAL ),
      m_running( true ),
      m_condition( &m_mutex ),
      m_connection_status( DISCONNECTED ),
      m_channel_locator_address( channel_locator_address )
{
    m_channel_locator_ior = "corbaloc::" + m_channel_locator_address + "/ChannelLocator";
    start_undetached();
    BOOST_LOG(m_log) << __FUNCTION__ << " - " << m_channel_locator_ior;
}


ChannelLocatorConnection::~ChannelLocatorConnection()
{
    BOOST_LOG(m_log) << __FUNCTION__ << " - " << m_channel_locator_ior << ", observer-size = " << m_observers.size();
}


void* ChannelLocatorConnection::run_undetached( void* )
{
    unsigned long abs_sec = 0;
    unsigned long abs_nsec = 0;

    while ( m_running )
    {
        while ( m_observers.empty() && m_running )
        {
            m_condition.wait();
        }

        if ( ! m_running )
        {
            break;
        }

        if ( CORBA::is_nil(m_channel_locator) )
        {
            m_channel_locator = Corba::string_to_object<TA_Base_Core::IChannelLocator>( m_channel_locator_ior );

            if ( CORBA::is_nil( m_channel_locator ) )
            {
                if ( m_connection_status != DISCONNECTED )
                {
                    m_connection_status = DISCONNECTED;
                    notify_observer( DISCONNECTED );
                }
            }
            else
            {
                try
                {
                    CORBA::String_var id = m_channel_locator->getID();
                    m_channel_mapping = m_channel_locator->getChannels();
                    m_connection_status = CONNECTED;
                    Notify::initialize( m_channel_mapping[0].channel );

                    if ( m_channel_locator_id.empty() )
                    {
                        m_channel_locator_id = id.in();
                        notify_observer( CONNECTED );
                    }
                    else if ( m_channel_locator_id != id.in() )
                    {
                        m_channel_locator_id = id.in();
                        notify_observer( RESTARTED );
                    }
                    else
                    {
                        notify_observer( CONNECTED );
                    }
                }
                catch ( CORBA::Exception& e )
                {
                    BOOST_LOG(m_log) << __FUNCTION__ << ":" << __LINE__ << " - " << Corba::exception_to_string(e);
                    m_channel_locator = TA_Base_Core::IChannelLocator::_nil();
                }
            }
        }
        else
        {
            try
            {
                CORBA::String_var id = m_channel_locator->getID();

                if ( m_channel_locator_id != id.in() )
                {
                    m_channel_locator_id = id.in();
                    m_channel_mapping = m_channel_locator->getChannels();
                    Notify::initialize( m_channel_mapping[0].channel );
                    notify_observer( RESTARTED );
                }
            }
            catch ( CORBA::Exception& e )
            {
                BOOST_LOG(m_log) << __FUNCTION__ << ":" << __LINE__ << " - " << Corba::exception_to_string(e);
                m_channel_locator = TA_Base_Core::IChannelLocator::_nil();
                m_connection_status = DISCONNECTED;
                notify_observer( DISCONNECTED );
            }
        }

        omni_thread::get_time( &abs_sec, &abs_nsec, ( m_connection_status == CONNECTED ? RESOLUTION_SUCCESS_DELAY_MS : RESOLUTION_FAILURE_DELAY_MS ), 0 );
        m_condition.timedwait( abs_sec, abs_nsec );
    }

    return NULL;
}


void ChannelLocatorConnection::terminate()
{
    m_running = false;
    m_observers.clear();
    m_condition.signal();
}


std::string ChannelLocatorConnection::get_channel_locator_ior()
{
    return m_channel_locator_ior;
}


TA_Base_Core::IChannelLocator_var ChannelLocatorConnection::get_channel_locator()
{
    return m_channel_locator;
}


CosNA::EventChannel_var ChannelLocatorConnection::get_channel( const std::string& name )
{
    for ( size_t i = 0; i < m_channel_mapping->length(); ++i )
    {
        if ( name == m_channel_mapping[i].channelName.in() )
        {
            return m_channel_mapping[i].channel;
        }
    }

    return CosNA::EventChannel::_nil();
}


void ChannelLocatorConnection::notify_observer( EConnectionStatus status )
{
    const char* s[] = { "CONNECTED", "DISCONNECTED", "RESTARTED" };
    BOOST_LOG(m_log) << __FUNCTION__ << " - " << s[status] << " (" << m_channel_locator_address << "), observers-size=" << m_observers.size();

    for ( std::set<IChannelLocatorObserver*>::iterator it = m_observers.begin(); it != m_observers.end(); ++it )
    {
        if ( status == CONNECTED )
        {
            (*it)->connection_connected();
        }
        else if ( status == DISCONNECTED )
        {
            (*it)->connection_disconnected();
        }
        else
        {
            (*it)->connection_restarted();
        }
    }
}


void ChannelLocatorConnection::register_observer( IChannelLocatorObserver* observer )
{
    m_observers.insert( observer );
    notify_observer( m_connection_status );
    m_condition.signal();
}


void ChannelLocatorConnection::deregister_observer( IChannelLocatorObserver* observer )
{
    m_observers.erase( observer );
}
