#ifndef PROXYMODELWITHHEADERMODELS_H
#define PROXYMODELWITHHEADERMODELS_H


#include <QSortFilterProxyModel>
#include <QPointer>

#include "hierarchicalheaderview.h"

class ProxyModelWithHeaderModels: public QSortFilterProxyModel
{
    Q_OBJECT

    QPointer<QAbstractItemModel> _horizontalHeaderModel;
    QPointer<QAbstractItemModel> _verticalHeaderModel;

public:
    ProxyModelWithHeaderModels(QObject* parent=0);

    QVariant data(const QModelIndex& index, int role=Qt::DisplayRole) const;

    void setHorizontalHeaderModel(QAbstractItemModel* model);

    void setVerticalHeaderModel(QAbstractItemModel* model);
};

#endif // PROXYMODELWITHHEADERMODELS_H
