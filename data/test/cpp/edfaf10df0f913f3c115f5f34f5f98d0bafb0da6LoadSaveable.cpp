
#include "LoadSaveable.h"

namespace Ice
{

	LoadSaveable::LoadSaveable(void)
	{
	}


	LoadSaveable::~LoadSaveable(void)
	{
	}

	void LoadSaveable::AddLoadSaveAtom(Ogre::String type, void *data, Ogre::String description)
	{
	}
	void LoadSaveable::Save(LoadSave::SaveSystem& mgr)
	{
		SaveObjects(mgr);
		for (auto i = mLoadSaveProperties.begin(); i != mLoadSaveProperties.end(); i++)
		{
			mgr.SaveAtom(i->type, i->data, i->description);
		}
	}
	void LoadSaveable::Load(LoadSave::LoadSystem& mgr)
	{
		LoadObjects(mgr);
		for (auto i = mLoadSaveProperties.begin(); i != mLoadSaveProperties.end(); i++)
		{
			mgr.LoadAtom(i->type, i->data);
		}
	}
}