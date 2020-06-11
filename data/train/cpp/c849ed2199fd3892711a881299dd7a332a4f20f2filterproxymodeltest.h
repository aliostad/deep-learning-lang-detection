#ifndef FILTERPROXYMODELTEST_H
#define FILTERPROXYMODELTEST_H
#include <QWidget>
#include <QListView>
#include <QStringListModel>
#include <QSortFilterProxyModel>
#include <QHBoxLayout>

class FilterProxyModelTest: public QWidget
{
    Q_OBJECT
private:
    QStringListModel* _model;
    QSortFilterProxyModel* _proxyModel;
    QListView* _viewModel;
    QListView* _viewProxyModel;




public:
    FilterProxyModelTest(){
        QHBoxLayout* layout = new QHBoxLayout;
        _model = new QStringListModel(QStringList()<<"Aaab"<<"Aaaa"<<"bbbb");

        _viewModel = new QListView;
        _viewModel->setModel(_model);


        _proxyModel = new QSortFilterProxyModel;
        _proxyModel->setSourceModel(_model);
        _proxyModel->setFilterWildcard("A*");

        _viewProxyModel = new QListView;
        _viewProxyModel->setModel(_proxyModel);

        layout->addWidget(_viewModel);
        layout->addWidget(_viewProxyModel);

        setLayout(layout);
    }

};

#endif // FILTERPROXYMODELTEST_H
