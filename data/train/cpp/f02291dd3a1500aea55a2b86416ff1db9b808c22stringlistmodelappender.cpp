#include "stringlistmodelappender.h"

StringListModelAppender::StringListModelAppender(QStringListModel *model)
{
    setStringListModel(model);
}

StringListModelAppender::~StringListModelAppender()
{
}

void StringListModelAppender::setStringListModel(QStringListModel *model)
{
    m_logModel = model;
    stringlist = new QStringList();
    m_logModel->setStringList(*stringlist);
}

void StringListModelAppender::append(const QDateTime& timeStamp, Logger::LogLevel logLevel, const char* file, int line,
                                     const char* function, const QString& message)
{
    QMutexLocker locker(&m_logModelMutex);
    stringlist->insert(0,formattedString(timeStamp, logLevel, file, line, function, message));
    m_logModel->setStringList(*stringlist );
}
