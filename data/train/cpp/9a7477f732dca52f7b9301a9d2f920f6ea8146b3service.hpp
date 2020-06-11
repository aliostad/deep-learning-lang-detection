#ifndef __SERVICE_HPP__
#define __SERVICE_HPP__

#include <QObject>

namespace bb
{
    class Application;
    namespace platform
    {
        class Notification;
    }
    namespace system
    {
        class InvokeManager;
        class InvokeRequest;
    }
}

class Service : public QObject
{
    Q_OBJECT

public:
    Service();
    virtual ~Service() {}

private slots:
    void handleInvoke(const bb::system::InvokeRequest &);
    void onTimeout();

private:
    void triggerNotification();

    bb::platform::Notification * m_notify;
    bb::system::InvokeManager * m_invokeManager;
};

#endif /* __SERVICE_HPP__ */
