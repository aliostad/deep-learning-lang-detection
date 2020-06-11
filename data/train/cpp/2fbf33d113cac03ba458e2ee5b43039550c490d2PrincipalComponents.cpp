#include "PrincipalComponents.h"

#include <QDataStream>

QDataStream& operator>>( QDataStream& Stream, common::models::PrincipalComponents& Value )
{
  Stream >> Value.EigenValues;
  Stream >> Value.EigenVectors;
  Stream >> Value.NEigs;
  Stream >> Value.NEigs2D;
  Stream >> Value.NEigsFinal;
  Stream >> Value.BMax;
  Stream >> Value.BMaxFinal;
  return Stream;
}

QDataStream& operator<<( QDataStream& Stream, const common::models::PrincipalComponents& Value )
{
  Stream << Value.EigenValues;
  Stream << Value.EigenVectors;
  Stream << Value.NEigs;
  Stream << Value.NEigs2D;
  Stream << Value.NEigsFinal;
  Stream << Value.BMax;
  Stream << Value.BMaxFinal;
  return Stream;
}
