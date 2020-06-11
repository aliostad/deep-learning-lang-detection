
#ifndef __LOAD_MODEL_H__
#define __LOAD_MODEL_H__

#include "cocos2d.h"

namespace Cocos3DEditor
{

class LoadModel 
{
public:
	static LoadModel* getInstance( void )
	{
		static LoadModel* instance = nullptr;
		if( instance == nullptr )
		{
			instance = new LoadModel();
		}
		return instance;
	}

	~LoadModel();
	cocos2d::Sprite3D* loadModelData( const std::string& filePath );
	cocos2d::Sprite3D* loadModelData( const std::string& filePath, const std::string& extension );

private:
	LoadModel();
	LoadModel( const LoadModel& obj ) {}
	LoadModel& operator=( const LoadModel& obj ) {}
};

}


#endif // __LOAD_MODEL_H__
