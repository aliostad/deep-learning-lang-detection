#pragma once
#include "KVARCO.h"
#include "LoadItem.h"

class LoadThread
{
public:
	typedef xtal::SmartPtr<LoadItem::BaseLoadItem>	LoadBasePtrX;
	typedef std::vector<LoadBasePtrX>				LoadBasePtrXVector;
	typedef boost::shared_ptr<boost::thread>		ThreadPtr;

private:
	LoadBasePtrXVector	LoadFileList;

	void AnyPtrToVector_LoadItem(xtal::AnyPtr load_list);
public:
	
	LoadThread(xtal::AnyPtr load_list);
	virtual ~LoadThread();

	void DataLoad();

	static ThreadPtr ThisThread;
	static bool IsEnded();
	static void Release();
};