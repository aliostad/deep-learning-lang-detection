/****************************************************************************
**
** This file is part of the Qt Extended Opensource Package.
**
** Copyright (C) 2009 Trolltech ASA.
**
** Contact: Qt Extended Information (info@qtextended.org)
**
** This file may be used under the terms of the GNU General Public License
** version 2.0 as published by the Free Software Foundation and appearing
** in the file LICENSE.GPL included in the packaging of this file.
**
** Please review the following information to ensure GNU General Public
** Licensing requirements will be met:
**     http://www.fsf.org/licensing/licenses/info/GPLv2.html.
**
**
****************************************************************************/

#include <QFavoriteServicesModel>
#include <QSpeedDial>

#include <QtopiaApplication>
#include <shared/qtopiaunittest.h>


//TESTED_CLASS=QFavoriteServicesModel
//TESTED_FILES=src/libraries/qtopia/qfavoriteservices.h

/*
    The tst_QFavoriteServicesModel class provides unit tests for the QFavoriteServicesModel class.
*/
class tst_QFavoriteServicesModel : public QObject
{
Q_OBJECT
private slots:
    void init();
    void initTestCase();

    void modifyTest();
    void moveTest();
    void modelTest();
};

QTEST_APP_MAIN( tst_QFavoriteServicesModel, QtopiaApplication )
#include "tst_qfavoriteservicesmodel.moc"

namespace QTest {
    template<>
    char *toString(const QtopiaServiceDescription &s)
    {
        QByteArray ba = "QtopiaServiceDescription(";
        if (!s.isNull()) {
            ba += "request=\"";
            ba += s.request().service().toLocal8Bit();
            ba += "::";
            ba += s.request().message().toLocal8Bit();
            ba += "\",label=\"";
            ba += s.label().toLocal8Bit();
            ba += "\",icon=\"";
            ba += s.iconName().toLocal8Bit();
            ba += "\"";
        }
        ba += ")";
        return qstrdup(ba.constData());
    }
}

/*!
    initTestCase() function called once before all tests.
    Clears the table.
*/
void tst_QFavoriteServicesModel::initTestCase()
{
    //It starts with the 1: Call VoiceMail which is default.
    QFavoriteServicesModel model;
    model.remove(model.index(0));
    QVERIFY(!model.rowCount());
}

/*!
    init() function called before each testcase.
    empties the table
*/
void tst_QFavoriteServicesModel::init()
{
    QFavoriteServicesModel model;
    int max = model.rowCount();
    for(int i = 0; i<max; i++)
        model.remove(model.index(0));
}

/*!
  Tests the QFavoriteServicesModel modification functions,
  insert and remove, as well as description.
*/
void tst_QFavoriteServicesModel::modifyTest()
{
    int numDescs=5;
    QtopiaServiceDescription test[numDescs];
    for(int i = 0; i<numDescs; i++){
        test[i] = QtopiaServiceDescription(QtopiaServiceRequest(QString("test%1").arg(i),
                        QString("test%1").arg(i)),QString("test%1").arg(i),
                        QString("test%1").arg(i));
    }
    QtopiaServiceDescription found;
    QFavoriteServicesModel model;

    for(int i = 0; i<100; i++){
        found = model.description(model.index(i));
        QVERIFY(found.isNull());
    }
    for(int i = 0; i<(100-numDescs); i++){
        model.insert(QModelIndex(),test[i%numDescs]);
    }
    QCOMPARE(model.rowCount(), numDescs);//Should not allow duplicates
    for(int i = 0; i<numDescs; i++){
        model.insert(model.index(i),test[i]);
    }
    for(int i = 0; i<numDescs; i++){
        found = model.description(model.index(i));
        QVERIFY(!found.isNull());
        QCOMPARE(found, test[i]);
    }

    //On remove items should slide down.
    for(int i = 1; i<numDescs-1; i++){
        model.remove(model.index(1));
    }
    for(int i = 2; i<numDescs; i++){
        found = model.description(model.index(i));
        QVERIFY(found.isNull());
    }
    found=model.description(model.index(0));
    QVERIFY(!found.isNull());
    QCOMPARE(found,test[0]);
    found=model.description(model.index(1));
    QVERIFY(!found.isNull());
    QCOMPARE(found,test[99%numDescs]);
    model.remove(model.index(1));
    found=model.description(model.index(1));
    QVERIFY(found.isNull());
    model.remove(model.index(0));
    found=model.description(model.index(0));
    QVERIFY(found.isNull());
}


/*!
  Tests the QFavoriteServicesModel move function
*/
void tst_QFavoriteServicesModel::moveTest()
{
    QtopiaServiceDescription a(QtopiaServiceDescription(QtopiaServiceRequest("a","a"),"a","a"));
    QtopiaServiceDescription b(QtopiaServiceDescription(QtopiaServiceRequest("b","b"),"b","b"));
    QtopiaServiceDescription c(QtopiaServiceDescription(QtopiaServiceRequest("c","c"),"c","c"));
    QtopiaServiceDescription d(QtopiaServiceDescription(QtopiaServiceRequest("d","d"),"d","d"));
    QtopiaServiceDescription e(QtopiaServiceDescription(QtopiaServiceRequest("e","e"),"e","e"));
    QtopiaServiceDescription f(QtopiaServiceDescription(QtopiaServiceRequest("f","f"),"f","f"));
    QtopiaServiceDescription g(QtopiaServiceDescription(QtopiaServiceRequest("g","g"),"g","g"));
    QtopiaServiceDescription h(QtopiaServiceDescription(QtopiaServiceRequest("h","h"),"h","h"));
    QtopiaServiceDescription i(QtopiaServiceDescription(QtopiaServiceRequest("i","i"),"i","i"));
    QtopiaServiceDescription j(QtopiaServiceDescription(QtopiaServiceRequest("j","j"),"j","j"));
    QFavoriteServicesModel model;
    model.insert(model.index(0),a);
    model.insert(QModelIndex() ,b);
    model.insert(QModelIndex() ,c);
    model.insert(QModelIndex() ,d);
    model.insert(QModelIndex() ,e);
    model.insert(QModelIndex() ,f);
    model.insert(QModelIndex() ,g);
    model.insert(QModelIndex() ,h);
    model.insert(QModelIndex() ,i);
    model.insert(QModelIndex() ,j);

    QCOMPARE(model.description(model.index(0)),a);
    QCOMPARE(model.description(model.index(1)),b);
    QCOMPARE(model.description(model.index(2)),c);
    QCOMPARE(model.description(model.index(3)),d);
    QCOMPARE(model.description(model.index(4)),e);
    QCOMPARE(model.description(model.index(5)),f);
    QCOMPARE(model.description(model.index(6)),g);
    QCOMPARE(model.description(model.index(7)),h);
    QCOMPARE(model.description(model.index(8)),i);
    QCOMPARE(model.description(model.index(9)),j);

    model.move(model.index(0),model.index(1));

    QCOMPARE(model.description(model.index(0)),b);
    QCOMPARE(model.description(model.index(1)),a);
    QCOMPARE(model.description(model.index(2)),c);
    QCOMPARE(model.description(model.index(3)),d);
    QCOMPARE(model.description(model.index(4)),e);
    QCOMPARE(model.description(model.index(5)),f);
    QCOMPARE(model.description(model.index(6)),g);
    QCOMPARE(model.description(model.index(7)),h);
    QCOMPARE(model.description(model.index(8)),i);
    QCOMPARE(model.description(model.index(9)),j);

    model.move(model.index(1),model.index(9));

    QCOMPARE(model.description(model.index(0)),b);
    QCOMPARE(model.description(model.index(1)),c);
    QCOMPARE(model.description(model.index(2)),d);
    QCOMPARE(model.description(model.index(3)),e);
    QCOMPARE(model.description(model.index(4)),f);
    QCOMPARE(model.description(model.index(5)),g);
    QCOMPARE(model.description(model.index(6)),h);
    QCOMPARE(model.description(model.index(7)),i);
    QCOMPARE(model.description(model.index(8)),j);
    QCOMPARE(model.description(model.index(9)),a);

    model.move(model.index(9),model.index(5));

    QCOMPARE(model.description(model.index(0)),b);
    QCOMPARE(model.description(model.index(1)),c);
    QCOMPARE(model.description(model.index(2)),d);
    QCOMPARE(model.description(model.index(3)),e);
    QCOMPARE(model.description(model.index(4)),f);
    QCOMPARE(model.description(model.index(5)),a);
    QCOMPARE(model.description(model.index(6)),g);
    QCOMPARE(model.description(model.index(7)),h);
    QCOMPARE(model.description(model.index(8)),i);
    QCOMPARE(model.description(model.index(9)),j);

    model.move(model.index(4),model.index(5));

    QCOMPARE(model.description(model.index(0)),b);
    QCOMPARE(model.description(model.index(1)),c);
    QCOMPARE(model.description(model.index(2)),d);
    QCOMPARE(model.description(model.index(3)),e);
    QCOMPARE(model.description(model.index(4)),a);
    QCOMPARE(model.description(model.index(5)),f);
    QCOMPARE(model.description(model.index(6)),g);
    QCOMPARE(model.description(model.index(7)),h);
    QCOMPARE(model.description(model.index(8)),i);
    QCOMPARE(model.description(model.index(9)),j);
}

/*!
  Tests the QFavoriteServicesModel model functions,
  including rowCount and data. Also speedDialInput
  and description, very similar to the data functions.
  It also tests indexOf(QtopiaServiceDescription)
*/
void tst_QFavoriteServicesModel::modelTest()
{
    QtopiaServiceDescription a(QtopiaServiceDescription(QtopiaServiceRequest("a","a"),"a","a2"));
    QtopiaServiceDescription b(QtopiaServiceDescription(QtopiaServiceRequest("b","b"),"b","b2"));
    QFavoriteServicesModel model;
    model.insert(QModelIndex(),a);
    model.insert(QModelIndex(),b);
    QSpeedDial::set("1",a);

    QCOMPARE(model.rowCount(),2);
    QCOMPARE(model.description(model.index(0)),a);
    QCOMPARE(model.indexOf(a).row(),0);
    QCOMPARE(model.data(model.index(0),Qt::DisplayRole).toString(),QString("a"));
    QCOMPARE(model.description(model.index(1)),b);
    QCOMPARE(model.indexOf(b).row(),1);
    QCOMPARE(model.data(model.index(1),Qt::DisplayRole).toString(),QString("b"));
    QCOMPARE(model.speedDialInput(model.index(0)),QString("1"));
    QCOMPARE(model.data(model.index(0),QFavoriteServicesModel::SpeedDialInputRole).toString(),QString("1"));
    QCOMPARE(model.data(model.index(1),QFavoriteServicesModel::SpeedDialInputRole).toString(),QString(""));
}
