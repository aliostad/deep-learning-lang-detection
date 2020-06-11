#ifndef LOCATOR_H
#define LOCATOR_H

#include <QObject>
#include <QDebug>
#include <QGeoPositionInfoSource>

class Locator : public QObject {
    Q_OBJECT

public:
    explicit Locator(QObject *parent = 0);
    ~Locator();

private:
    QGeoPositionInfoSource* source;
    double lat, lon;

signals:
    void response(bool status, double lat, double lon); // READ ME!

public slots:
    void request(); // CALL ME!

private slots:
    void getPositionUpdateSuccess(QGeoPositionInfo info);
    void getPositionUpdateFail();

};

#endif // LOCATOR_H
