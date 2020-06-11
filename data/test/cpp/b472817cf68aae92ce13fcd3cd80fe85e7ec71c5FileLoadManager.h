
#ifndef __FILE_LOAD_MANAGER_H__
#define __FILE_LOAD_MANAGER_H__

#include "cocos2d.h"

namespace Cocos3DEditor
{
	
class FileLoadManager
{
public:
	static FileLoadManager* getInstance( void )
	{
		static FileLoadManager* instance = nullptr;
		if( instance == nullptr )
		{
			instance = new FileLoadManager();
		}
		return instance;
	}

	~FileLoadManager();

	cocos2d::Sprite3D* getSprite3D( int number );
	cocos2d::Sprite3D* getSprite3D( const std::string& fileName );

private:
	FileLoadManager();
	FileLoadManager( const FileLoadManager& obj ) {}
	FileLoadManager& operator=( const FileLoadManager& obj ) {}

private:
	class Private;
	Private* p;
};

}

#endif // __FILE_LOAD_MANAGER_H__
