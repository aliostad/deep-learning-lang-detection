#ifndef IO_H
#define IO_H
#include "declarations.h"
//#include <QTcpSocket>

/****************************************************************
 * This module contains serialization methods
 ****************************************************************/

QDataStream &operator<<(QDataStream & s, const char &c);
QDataStream &operator>>(QDataStream & s, char &c);

QDataStream &operator<<(QDataStream & s, const tile &t);
QDataStream &operator>>(QDataStream & s, tile &t);

QDataStream &operator<<(QDataStream & s, _map &m);
QDataStream &operator>>(QDataStream & s, _map &m);

QDataStream &operator<<(QDataStream & s, const player &p);
QDataStream &operator>>(QDataStream & s, player &p);

QDataStream &operator<<(QDataStream & s, const weapon &w);
QDataStream &operator>>(QDataStream & s, weapon &w);

QDataStream &operator<<(QDataStream & s, const projectile &p);
QDataStream &operator>>(QDataStream & s, projectile &p);

int sizeoftile();
int sizeofmap(_map *level);
int sizeofplayer();
int sizeofweapon();
int sizeofprojectile();

#endif // IO_H
