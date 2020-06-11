#include "dlanglocator.h"

#include <functional>

#include "codemodel/dmodel.h"
#include "dlangimagecache.h"
#include "dlangeditor.h"
#include "dlangoutlinemodel.h"

#include <utils/fileutils.h>
#include <texteditor/texteditor.h>
#include <texteditor/textdocument.h>
#include <coreplugin/editormanager/editormanager.h>
#include <utils/qtcassert.h>

using namespace DlangEditor;

DlangLocator::DlangLocator()
{
    setId("Classes and Methods");
    setDisplayName(tr("Dlang Classes, Enums and Functions"));
    setShortcutString(QString(QLatin1Char(':')));
    setPriority(Medium);
    setIncludedByDefault(false);
}

DlangLocator::~DlangLocator()
{

}

QList<Core::LocatorFilterEntry> DlangLocator::matchesFor(QFutureInterface<Core::LocatorFilterEntry> &future, const QString &origEntry)
{
    Q_UNUSED(future)
    Q_UNUSED(origEntry)
    return QList<Core::LocatorFilterEntry>();
}

void DlangLocator::accept(Core::LocatorFilterEntry selection) const
{
    Q_UNUSED(selection)
}

void DlangLocator::refresh(QFutureInterface<void> &future)
{
    Q_UNUSED(future)
}

