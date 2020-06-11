
#ifndef APPVIRTUALWORLD_H
#define APPVIRTUALWORLD_H

#include <string>
#include <map>
#include "Vector.hh" 
#include "Model.hh"
#include "IRCEProject.h"

using namespace std;

class AppVirtualWorld
{
private: int i3DModelIDCounter;

public: AppVirtualWorld(void);
public: virtual ~AppVirtualWorld(void);

public: IRCEProject * project;


public: void NewWorldFile( string worldFullPath );
public: void CleanVirtualWorld( );
public: void LoadVirtualWorld( string worldFullPath );
public: void SaveWorldFile( );
public: void Add3DModel( string modelType, string modelID, GzVector position );
public: void Update3DModel( Model * model, map<string,string> * properties );
public: void Update3DModelPosition( Model * model, GzVector position );
public: void Remove3DModel( Model * model );
public: void GetPropertyList( Model * model,map<string,string> ** modelProperties );
public: void SetPropertyList( Model * model,map<string,string> * modelProperties );
public: void AddChildModel( Model * parentModel, string strModelType, string strModelID, GzVector position );
public: void RemoveChildModel( Model * parentModel, Model * childModel );
};

#endif

