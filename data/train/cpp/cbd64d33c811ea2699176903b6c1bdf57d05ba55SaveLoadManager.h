#ifndef __SAVELOAD_MANAGER_H__
#define __SAVELOAD_MANAGER_H__

#include "cocos2d.h"
#include <vector>

class SaveLoadManager
{
	public:
		static SaveLoadManager* Instance();
		~SaveLoadManager();

		void setHighScores( std::vector<int>* pHighScores );
		void getHighScores( std::vector<int>* pHighScores );

		bool init();

	private:
		SaveLoadManager() {};
		SaveLoadManager(SaveLoadManager const&) {};
		SaveLoadManager& operator=(SaveLoadManager const&) {};
		static SaveLoadManager* m_pInstance;

		char keyBuf[64];
};

#endif /* __SAVELOAD_MANAGER_H__ */
