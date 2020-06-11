#include "pch.h"
#include "LoadThread.h"

LoadThread::ThreadPtr LoadThread::ThisThread;

LoadThread::LoadThread(xtal::AnyPtr load_list)
{
	AnyPtrToVector_LoadItem(load_list);
	ThisThread=ThreadPtr( new boost::thread(&LoadThread::DataLoad,&(*this)) );
}

void LoadThread::DataLoad()
{
	BOOST_FOREACH(LoadBasePtrX& i,LoadFileList)
	{
		i->Load();
	}
}

void LoadThread::Release()
{
	if(ThisThread)
	{
		ThisThread->join();
		ThisThread->interrupt();
		ThisThread.reset();
	}
}

LoadThread::~LoadThread()
{
	Release();
}

bool LoadThread::IsEnded()
{
	if(!ThisThread) return true;
	if(ThisThread->timed_join(posix_time::milliseconds(0)))
	{
		ThisThread->interrupt();
		ThisThread.reset();
		return true;
	}
	return false;
}

//Xtal依存
void LoadThread::AnyPtrToVector_LoadItem(xtal::AnyPtr load_list)
{
	xtal::ArrayPtr xlist=load_list.to_a();
	if(xtal::is_undefined(xlist)) return;

	for(DWORD i=0; i<xlist->size(); i++)
	{
		LoadBasePtrX tmp=
			xtal::unchecked_ptr_cast<LoadItem::BaseLoadItem>(xlist->at(i));
		LoadFileList.push_back(tmp);
	}
}
