/*******************************************************************************
* 版权所有(C) pyhcx 2009
* 文件名称	: DumpFile.cpp
* 当前版本	: 1.0.0.1
* 作    者	: 彭勇 (pyhcx@foxmail.com)
* 设计日期	: 2009年3月31日
* 内容摘要	: 
* 修改记录	: 
* 日    期		版    本		修改人		修改摘要

********************************************************************************/
/**************************** 条件编译选项和头文件 ****************************/

#include "StdAfx.h"
#include "DumpFile.h"

#include "ModuleList.h"
#include "DumpSystemInfo.h"
#include "DumpExceptionInfo.h"
#include "DumpStackInfo.h"
#include "DumpModuleInfo.h"
#include "DumpCpuInfo.h"

/********************************** 宏、常量 **********************************/

/********************************** 数据类型 **********************************/

/************************************ 变量 ************************************/

/********************************** 函数实现 **********************************/

/*********************************** 类实现 ***********************************/

CDumpFile::CDumpFile(LPCTSTR ptszFile)
{
	m_hDumpFile = ::CreateFile(ptszFile,GENERIC_WRITE,0,NULL,CREATE_ALWAYS,FILE_ATTRIBUTE_NORMAL,NULL);
}

CDumpFile::~CDumpFile(void)
{
	Close();
}

BOOL CDumpFile::DumpInfo(PEXCEPTION_POINTERS pExceptionInfo)
{
	if(m_hDumpFile==INVALID_HANDLE_VALUE) return FALSE ;

	CModuleList::Instance().UpdateModuleList();

	CDumpSystemInfo dumpSystem ;
	dumpSystem.Dump(m_hDumpFile);

	CDumpExceptionInfo dumpException(pExceptionInfo); ;
	dumpException.Dump(m_hDumpFile);

	CDumpCpuInfo dumpCPU(pExceptionInfo);
	dumpCPU.Dump(m_hDumpFile);

	CDumpStackInfo dumpStack(pExceptionInfo);
	dumpStack.Dump(m_hDumpFile);

	CDumpModuleInfo dumpModule ;
	dumpModule.Dump(m_hDumpFile);

	return TRUE ;
}

void CDumpFile::Close()
{
	if(m_hDumpFile!=INVALID_HANDLE_VALUE)
	{
		CloseHandle(m_hDumpFile);
		m_hDumpFile = INVALID_HANDLE_VALUE ;
	}
}