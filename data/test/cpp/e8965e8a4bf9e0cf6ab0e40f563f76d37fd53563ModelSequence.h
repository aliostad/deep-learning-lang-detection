#pragma once


//+-----------------------------------------------------------------------------
//| Included files
//+-----------------------------------------------------------------------------
#include "ModelBase.h"


//+-----------------------------------------------------------------------------
//| Model sequence data structure
//+-----------------------------------------------------------------------------
struct MODEL_SEQUENCE_DATA
{
	MODEL_SEQUENCE_DATA()
	{

	}

	std::string Name;

	FLOAT Rarity;
	FLOAT MoveSpeed;
	BOOL NonLooping;

	VECTOR2 Interval;
	EXTENT Extent;
};


//+-----------------------------------------------------------------------------
//| Model sequence class
//+-----------------------------------------------------------------------------
class MODEL_SEQUENCE
{
public:
	CONSTRUCTOR MODEL_SEQUENCE();
	DESTRUCTOR ~MODEL_SEQUENCE();

	VOID Clear();
	INT GetSize();

	MODEL_SEQUENCE_DATA& Data();

protected:
	MODEL_SEQUENCE_DATA SequenceData;

public:
	REFERENCE_OBJECT<MODEL*, MODEL_SEQUENCE*> ModelNodes;
};
