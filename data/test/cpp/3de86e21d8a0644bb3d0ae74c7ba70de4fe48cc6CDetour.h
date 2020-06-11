#ifndef _DETOUR_H_
#define _DETOUR_H_

#include "BaseHeader.h"

#define DECLARE_HOOK_API(ReturnType,CallType,SysApi,ApiArgs)\
	static ReturnType (CallType *Sys_##SysApi)##ApiArgs = SysApi;\
	static ReturnType CallType Hook_##SysApi##ApiArgs

#define DETOURS_ATTACH_API(SysApi) CDetour::DetourApi(&(PVOID&)Sys_##SysApi, Hook_##SysApi,true)
#define DETOURS_DETACH_API(SysApi) CDetour::DetourApi(&(PVOID&)Sys_##SysApi, Hook_##SysApi,false)

namespace Util
{
	/************************************************************************/
	/* 系统函数替换操作封装                                                 */
	/************************************************************************/
	class WIN32_API CDetour
	{
	public:
		//构造
		CDetour();

		//析构
		virtual ~CDetour();

	public:
		//替换函数地址
		static Bool DetourApi(void** pSysAddr, void* pUsrAddr, Bool bDetour = true);
	};
}
#endif
