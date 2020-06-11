#ifndef __LocatorData__
#define __LocatorData__

#include "Config.h"
#include "TL/Map.h"
#include "TL/MyString.h"

struct Locator
{
	NEWDEL_DECL
	float x;
	float y;
	float z;

	float qx;
	float qy;
	float qz;
	float qw;

	float sx;
	float sy;
	float sz;

	bool hasRef;
	String refName;
	PVRTMat4 matrix;
	float radius;
};

class LocatorData
{
public:
	NEWDEL_DECL
	LocatorData(void);
	~LocatorData(void);

	void AllocateLocators(int numofLocators);

	inline int GetNumOfLocators()
	{
		return mNumOfLocators;
	}

	inline Locator * GetLocator(int index)
	{
		return &mLocators[index];
	}

	inline Locator * GetLocator(String name)
	{	 
		if (!mLocatorsTable.FindByKey( name.GetPtr() ) )
		{
			STOP;
		}

		int val = (int)mLocatorsTable.GetByKey( name.GetPtr() );
		return &mLocators[val];
	}


	Locator * mLocators;
	int mNumOfLocators;
	Map mLocatorsTable;
};


#endif //__LocatorData__