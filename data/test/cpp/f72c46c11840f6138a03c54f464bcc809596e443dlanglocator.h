#ifndef DLANGLOCATOR_H
#define DLANGLOCATOR_H

#include <coreplugin/locator/ilocatorfilter.h>

#include <QObject>

namespace Core {
class IEditor;
}

namespace DlangEditor {

class DlangLocator : public Core::ILocatorFilter
{
    Q_OBJECT
public:
    DlangLocator();
    ~DlangLocator();

    // pure Core::ILocatorFilter
    virtual QList<Core::LocatorFilterEntry> matchesFor(QFutureInterface<Core::LocatorFilterEntry> &future, const QString &entry);
    virtual void accept(Core::LocatorFilterEntry selection) const;
    virtual void refresh(QFutureInterface<void> &future);
private:
};

} // namespace DlangEditor

#endif // DLANGLOCATOR_H
