#include "FileLoadUtil.h"
#include "MZDataManager.h"

using namespace cocos2d;

FileLoadUtil*FileLoadUtil::mFileLoadUtil=NULL;
FileLoadUtil*FileLoadUtil::sharedFileLoadUtil(){

	if (mFileLoadUtil=NULL)
	{
		mFileLoadUtil=new FileLoadUtil();
		if (mFileLoadUtil&&mFileLoadUtil->init())
		{
			mFileLoadUtil->retain();
			mFileLoadUtil->autorelease();
		}
		else{
			CC_SAFE_DELETE(mFileLoadUtil);
			mFileLoadUtil=NULL;
		}
	}

	return mFileLoadUtil;
}

bool 
	FileLoadUtil::init()
{
	return true;
}

CCArray* FileLoadUtil::getDataLines(const char*sFilePath)
{
	CCArray *linesList=CCArray::create();

	unsigned long pSize=0;
	unsigned char*chDatas=CCFileUtils::sharedFileUtils()->getFileData(sFilePath,"r",&pSize);

	CCString *str=CCString::createWithData(chDatas,pSize);

	
	linesList=MZDataManager::sharedDataManager()->splitstr(str->getCString(),"\n");

	return linesList;
}

