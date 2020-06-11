/*
*	Author: Chaitanya Agrawal (krypten)
*
*	Description:
*
*/

#include "Model.h"

// getter functions
TEXT Model::getKey() const
{
  return key;
}

Model::ModelValueType Model::getValueType() const
{
  return valueType;
}

void Model::getValue(ModelArray& mArray, bool& error) const
{
  if (!error && getValueType() == ModelValueType::ModelValueArray) {
    mArray = *(value.modelArray);
  } else {
    error = true;
  }
}

void Model::getValue(TEXT& mString, bool& error) const
{
  if (!error && getValueType() == ModelValueType::ModelValueString) {
    mString = *(value.modelString);
  } else {
    error = true;
  }
}

void Model::getValue(double& mDouble, bool& error) const
{
  if (!error && getValueType() == ModelValueType::ModelValueDouble) {
    mDouble = value.modelDouble;
  } else {
    error = true;
  }
}

void Model::getValue(int& mInt, bool& error) const
{
  if (!error && getValueType() == ModelValueType::ModelValueInt) {
    mInt = value.modelInt;
  } else {
    error = true;
  }
}


// setter function
void Model::setKey(TEXT mkey)
{
  key = mkey;
}

void Model::setValueType(ModelValueType type)
{
  valueType = type;
}

void Model::setValue(ModelArray* mArray)
{
  setValueType(ModelValueType::ModelValueArray);
  value.modelArray = mArray;
}

void Model::setValue(TEXT* mString)
{
  setValueType(ModelValueType::ModelValueString);
  value.modelString = mString;
}

void Model::setValue(double mDouble)
{
  setValueType(ModelValueType::ModelValueDouble);
  value.modelDouble = mDouble;
}

void Model::setValue(int mInt)
{
  setValueType(ModelValueType::ModelValueInt);
  value.modelInt = mInt;
}
