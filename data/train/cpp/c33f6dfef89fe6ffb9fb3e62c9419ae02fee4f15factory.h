#ifndef FACTORY_H
#define FACTORY_H

#include <QObject>

#include "TableModel/model.h"
#include "ProjectTree/tree.h"

namespace Model
{
    class Factory : public QObject
    {
        Q_OBJECT
    public:
        explicit Factory(QObject *parent = 0);
        ~Factory();

        TableModel::Model* getCompetences();
        TableModel::Model* getProjets();
        TableModel::Model* getActivites();
        TableModel::Model* getActivitesProjets();

        ProjectTree::Tree* getProjetTree();

    signals:

    public slots:

    private:
        TableModel::Model* mCompetences;
        TableModel::Model* mProjets;
        TableModel::Model* mActivites;
        TableModel::Model* mActivitesProjets;

        ProjectTree::Tree* mProjetTree;
    };
}

#endif // FACTORY_H
