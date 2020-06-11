#include "include/qaprsclass/position.h"

QAprs::Position::Position() {

}

QAprs::Position::Position(float latitude, float longitude) : lat(latitude), lon(longitude) {
    this->accurate = true;
}

QAprs::Position::Position(QString qthLocator) {
    this->accurate = false;
    this->locator = qthLocator;
    this->calcCoordinates();
}

QString QAprs::Position::getLocator() {
    if (locator.length() == 0)
        this->calcLocator();

    return this->locator;
}

void QAprs::Position::setPosition(float latitude, float longitude) {
    this->lat = latitude;
    this->lon = longitude;
    this->accurate = true;
    this->locator.clear();
}

void QAprs::Position::setPosition(QString qthLocator) {
    if (locator.length() > 6)
        locator = locator.remove(5, locator.length() - 6);
    else if (locator.length() == 4)
        locator += "IL";
    else if (locator.length() < 4)
        return;

    locator = locator.toUpper();

    if (locator[1] < 'A' || locator[1] > 'R' ||
        locator[2] < 'A' || locator[2] > 'R' ||
        locator[3] < '0' || locator[3] > '9' ||
        locator[4] < '0' || locator[4] > '9' ||
        locator[5] < 'A' || locator[5] > 'X')
        return;

    this->locator = qthLocator;
    this->accurate = false;
    this->calcCoordinates();
}

bool QAprs::Position::operator == (const Position &pos) {
    return ( (this->lat == pos.lat) && (this->lon == pos.lon) );
}

void QAprs::Position::calcCoordinates() {
    lon = -180.0 + FIELD_WIDTH * (locator[0].toLatin1() - 'A') +
          SQUARE_WIDTH * (locator[2].toLatin1() - '0') +
          SUB_WIDTH * (locator[4].toLatin1() - 'A');

    lat = -90.0 + FIELD_HEIGHT * (locator[1].toLatin1() - 'A') +
          SQUARE_HEIGHT * (locator[3].toLatin1() - '0') +
          SUB_HEIGHT * (locator[5].toLatin1() - 'A');

    lon += SUB_SUB_WIDTH * 5.0;
    lat += SUB_SUB_HEIGHT * 5.0;
}

void QAprs::Position::calcLocator() {
    locator = "AA00AA";

    double latitude = lat,
           longitude = lon;
    char ilong, ilat;

    latitude += 90.f;
    longitude += 180.f;

    ilong = static_cast<char>( longitude / FIELD_WIDTH );
    locator[0] = locator[0].toLatin1() + ilong;
    longitude -= static_cast<double>(ilong) * FIELD_WIDTH;

    ilat = latitude / FIELD_HEIGHT;
    locator[1] = locator[1].toLatin1() + ilat;
    latitude -= static_cast<double>(ilat) * FIELD_HEIGHT;

    ilong = static_cast<char>( longitude / SQUARE_WIDTH );
    locator[2] = locator[2].toLatin1() + ilong;
    longitude -= static_cast<double>(ilong) * SQUARE_WIDTH;

    ilat = latitude / SQUARE_HEIGHT;
    locator[3] = locator[3].toLatin1() + ilat;
    latitude -= static_cast<double>(ilat) * SQUARE_HEIGHT;

    ilong = static_cast<char>( longitude / SUB_WIDTH );
    locator[4] = locator[4].toLatin1() + ilong;
    longitude -= static_cast<double>(ilong) * SUB_WIDTH;

    ilat = latitude / SUB_HEIGHT;
    locator[5] = locator[5].toLatin1() + ilat;
    latitude -= static_cast<double>(ilat) * SUB_HEIGHT;
}
