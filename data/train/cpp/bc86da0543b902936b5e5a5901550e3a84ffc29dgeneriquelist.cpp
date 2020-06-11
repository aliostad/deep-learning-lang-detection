#include "generiquelist.h"
#include <QVBoxLayout>
#include <QStringListModel>

GeneriqueList::GeneriqueList(QWidget *parent) :
    AbstractList(parent)
{
    _tf=new TextFilter;
    _model=0;
    _zModel=new QSortFilterProxyModel(this);
    _zModel->setFilterCaseSensitivity(Qt::CaseInsensitive);
    connect(_tf,SIGNAL(filterExp(QString)),_zModel,SLOT(setFilterRegExp(QString)));
    QVBoxLayout *vbl=new QVBoxLayout;
    vbl->setMargin(0);vbl->setSpacing(0);

    vbl->addWidget(_tf);

    _ml=new MyListWidget;
    _zL=_ml;

    vbl->addWidget(_ml);

    setLayout(vbl);
}
void GeneriqueList::setModel(QAbstractItemModel *im)
{
    _model=im;
    _zModel->setSourceModel(_model);

    _ml->setModel(_zModel);
}
void GeneriqueList::setModel(QList<QString> s)
{
    if(_model)
        delete _model;
    _model=new QStringListModel(s,this);
    _zModel->setSourceModel(_model);
    _ml->setModel(_zModel);
}
void GeneriqueList::set_sh(ShowCreators *s)
{
    _ml->set_sh(s);
}
