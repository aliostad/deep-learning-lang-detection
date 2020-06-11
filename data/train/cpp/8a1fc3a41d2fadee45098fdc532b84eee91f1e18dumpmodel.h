#ifndef DUMPMODEL_H
#define DUMPMODEL_H

#include <QStandardItemModel>
#include "stores/dumpstore.h"

class DumpStore;

class DumpModel : public QStandardItemModel
{
    Q_OBJECT
public:
    DumpModel(DumpStore* parentStore_);

    DumpModel& operator <<(DumpSummary *dump_summary_);
    DumpModel& operator <<(DumpSummaryPacket *dump_summary_packet_);

    int getNumberOfDumps();
    int checkDumpExists(qulonglong dumpId_);

    void setMyTimestampFmt(const QString &value);

private:
    DumpStore* parentStore;

    QString myTimestampFmt;
    void appendSummaryPacket(QStandardItem *item_, DumpSummaryPacket *dump_summary_packet_);
};

#endif // DUMPMODEL_H
