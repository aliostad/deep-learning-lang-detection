#include "FlashRecovery.h"

BEGIN_NAMESPACE_FR

Flash::Flash(void)
{
}

Flash::~Flash(void)
{
	ClearDumpList();
}

void Flash::ClearDumpList()
{
	DWORD dump_count = dump_list.size();
	for (DWORD i = 0; i < dump_count; ++i)
		delete dump_list[i];
	dump_list.clear();
}

void Flash::AddDump(TCHAR *file_name)
{
	Dump *dump = new Dump(file_name);
	AddDump(dump);
}

void Flash::DeleteDump(DWORD num)
{
	delete (dump_list[num]);
	dump_list.erase(dump_list.begin() + num);
}

END_NAMESPACE_FR
