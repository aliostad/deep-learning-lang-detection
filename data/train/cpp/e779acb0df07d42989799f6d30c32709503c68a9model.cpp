#include "model.h"

Model::Model()
{
}

Model::~Model()
{
}


QStringList Model::getUsers()
{
    return QStringList();
}

QString Model::getUserAt(const int & pos)
{
    QString retour(QString::number(pos));
    return retour;
}

int Model::getUsersSize()
{
    return 0;
}

void Model::addUser(QString name)
{
}

QStringList Model::getExos()
{
    return QStringList();
}

QVector<int> Model::getNbTentatives()
{
    QVector<int> r;
    return r;
}

QVector<int> Model::getMoyennes()
{
    QVector<int> r;
    return r;
}

void Model::next()
{
}

void Model::prev()
{
}

QString Model::firstExo()
{
    return "";
}

QString Model::secondExo()
{
    return "";
}

QString Model::getExo()
{
    return "";
}

QString Model::getDesc()
{
    return "";
}

void Model::nextPage()
{
}

void Model::answer(int answer)
{
}
