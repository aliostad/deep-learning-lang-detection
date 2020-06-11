#ifndef __CARDUI_HPP__
#define __CARDUI_HPP__

#include <bb/system/InvokeManager>

#include "ApplicationUIBase.hpp"


namespace bb {
    namespace system {
        class InvokeManager;
        class InvokeRequest;
    }
}

class CardUI: public ApplicationUIBase
{
    Q_OBJECT

public:
    CardUI(bb::system::InvokeManager* invokeManager);
    virtual ~CardUI() {}

signals:
    void memoChanged(const QString &memo);

private slots:
    void onInvoked(const bb::system::InvokeRequest& request);
    void cardPooled(const bb::system::CardDoneMessage& doneMessage);
};

#endif /* __CARDUI_HPP__ */
