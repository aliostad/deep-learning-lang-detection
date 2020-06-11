#include "Context.h"

QDataStream& operator>>( QDataStream& Stream, AlgVecShpInput& Value )
{
  Stream >> Value.Detector;
  return Stream;
}

QDataStream& operator<<( QDataStream& Stream, const AlgVecShpInput& Value )
{
  Stream << Value.Detector;
  return Stream;
}

QDataStream& operator>>( QDataStream& Stream, AlgVecShpOutput& Out )
{
  Stream >> Out.Value;
  return Stream;
}

QDataStream& operator<<( QDataStream& Stream, const AlgVecShpOutput& In )
{
  Stream << In.Value;
  return Stream;
}

QDataStream& operator>>( QDataStream& Stream, AlgVecShpInOut& Value )
{
  Stream >> Value.In;
  Stream >> Value.Out;
  return Stream;
}

QDataStream& operator<<( QDataStream& Stream, const AlgVecShpInOut& Value )
{
  Stream << Value.In;
  Stream << Value.Out;
  return Stream;
}
