#pragma once

//+-----------------------------------------------------------------------------
//| Included files
//+-----------------------------------------------------------------------------
#include "Misc.h"


//+-----------------------------------------------------------------------------
//| Pre-declared classes
//+-----------------------------------------------------------------------------
class MODEL_GEOSET;
class MODEL_TEXTURE;


//+-----------------------------------------------------------------------------
//| Model info data structure
//+-----------------------------------------------------------------------------
struct MODEL_INFO_DATA
{
	MODEL_INFO_DATA()
	{
		Version = MODEL_DEFAULT_VERSION;
		Name = "Name";
		AnimationFile = "";

		BlendTime = 150;
	}

	DWORD Version;
	std::string Name;
	std::string AnimationFile;

	EXTENT Extent;
	INT BlendTime;
};


//+-----------------------------------------------------------------------------
//| Model data structure
//+-----------------------------------------------------------------------------
struct MODEL_DATA
{
	MODEL_DATA()
	{
		//Empty
	}

	MODEL_INFO_DATA Info;

	SIMPLE_CONTAINER<MODEL_TEXTURE*> TextureContainer;
	SIMPLE_CONTAINER<MODEL_GEOSET*> GeosetContainer;
};



//+-----------------------------------------------------------------------------
//| Model class
//+-----------------------------------------------------------------------------
class MODEL
{
public:
	CONSTRUCTOR MODEL();
	DESTRUCTOR ~MODEL();
	
	VOID Clear();

	MODEL_DATA& Data();

	VOID Render(INT TimeDifference);

	BOOL AddTexture(MODEL_TEXTURE* Texture);
	BOOL AddGeoset(MODEL_GEOSET* Geoset, BOOL Imported = FALSE);

protected:

	MODEL_DATA ModelData;

	FLOAT BoundsRadius;
	VECTOR3 BoundsCenter;
};


//+-----------------------------------------------------------------------------
//| Global objects
//+-----------------------------------------------------------------------------
extern MODEL Model;


//+-----------------------------------------------------------------------------
//| Post-included files
//+-----------------------------------------------------------------------------
#include "Graphics.h"
#include "ModelTexture.h"
#include "ModelGeoset.h"
