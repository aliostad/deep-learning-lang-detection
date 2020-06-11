#ifndef LOADRELATIONTEST_H
#define LOADRELATIONTEST_H

#include <QObject>
#include <QtTest/QtTest>
#include <EBPdb/connection.hxx>
#include "AutoTest.h"
/**
  * \brief Testet das Laden der Relationen zwischen Datenbankobjekten
  */
class LoadRelationTest : public QObject
{
    Q_OBJECT
    QSharedPointer< ebp::connection > aConnection;

private slots:
    void initTestCase();
    void loadMitarbeiter();
    void loadWohngruppenereignis();
    void loadBewohner();
    void loadBewohnerEreignis();
    void loadVerfuegung();
    void loadDokumentation();
    void loadAbwesenheit();
    void loadProtokoll();
    void loadProjekt();
    void loadLeistungstraeger();
    void loadBetreuung();
    void cleanupTestCase();

};
DECLARE_TEST(LoadRelationTest)
#endif // LOADRELATIONTEST_H
