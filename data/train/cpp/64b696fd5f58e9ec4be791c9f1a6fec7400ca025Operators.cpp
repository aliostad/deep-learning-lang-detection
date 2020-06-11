#include "QueryValues.h"
#include "Photos.h"
#include "Faces.h"
#include "Persons.h"

#include <QDataStream>

QDataStream& operator>>( QDataStream& Stream, DBQueryValue& Value )
{
  Stream >> Value.vint64;
  return Stream;
}

QDataStream& operator<<( QDataStream& Stream, const DBQueryValue& Value )
{
  Stream << Value.vint64;
  return Stream;
}

QDataStream& operator>>( QDataStream& Stream, DBPhotos::QueryKey& Value )
{
  quint8 key;
  Stream >> key;
  Value = static_cast<DBPhotos::QueryKey>(key);
  return Stream;
}

QDataStream& operator<<( QDataStream& Stream, const DBPhotos::QueryKey& Value )
{
  Stream << quint8(Value);
  return Stream;
}

QDataStream& operator>>( QDataStream& Stream, DBFaces::QueryKey& Value )
{
  quint8 key;
  Stream >> key;
  Value = static_cast<DBFaces::QueryKey>(key);
  return Stream;
}

QDataStream& operator<<( QDataStream& Stream, const DBFaces::QueryKey& Value )
{
  Stream << quint8(Value);
  return Stream;
}

QDataStream& operator>>( QDataStream& Stream, DBPersons::QueryKey& Value )
{
  quint8 key;
  Stream >> key;
  Value = static_cast<DBPersons::QueryKey>(key);
  return Stream;
}

QDataStream& operator<<( QDataStream& Stream, const DBPersons::QueryKey& Value )
{
  Stream << quint8(Value);
  return Stream;
}
