#ifndef MODELADMINISTRATOR_H
#define MODELADMINISTRATOR_H

#include <QObject>
#include <QSqlTableModel>
#include <QSqlRelationalTableModel>


class modelAdministrator : public QObject
{ Q_OBJECT


public:

    explicit modelAdministrator(QObject *parent = 0);

    QSqlTableModel* regieModel() const { return regie_model ; }
    QSqlRelationalTableModel* gestionnaireModel() const { return gestionnaire_model ; }
    QSqlRelationalTableModel* clientModel() const { return client_model ; }

protected:

    QSqlTableModel* regie_model ;
    QSqlRelationalTableModel* gestionnaire_model ;
    QSqlRelationalTableModel* client_model ;

signals:
    
public slots:

    
};

#endif // MODELADMINISTRATOR_H
