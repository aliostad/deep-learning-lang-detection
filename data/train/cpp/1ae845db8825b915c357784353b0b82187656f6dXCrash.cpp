#include "stdafx.h"
#include "XCrash.h"
#include "CDumpCore.h"

HRESULT XCrashDump::Initialize(const TCHAR* lpszDumpFileName_no_suffix)
{
    CDumpCore::Instance()->SetOriginalFileName(_T("CrashDump"));

    CDumpCore::Instance()->SetDumpSwitch(enDumpLog, FALSE);
    CDumpCore::Instance()->SetDumpSwitch(enDumpBasicInfo, FALSE);
    CDumpCore::Instance()->SetDumpSwitch(enDumpModuleList, FALSE);
    CDumpCore::Instance()->SetDumpSwitch(enDumpWindowList, FALSE); // 由于挂起窗口线程,不能查询窗口
    CDumpCore::Instance()->SetDumpSwitch(enDumpProcessList, FALSE);
    CDumpCore::Instance()->SetDumpSwitch(enDumpRegister, FALSE);
    CDumpCore::Instance()->SetDumpSwitch(enDumpCallStack, TRUE);
    CDumpCore::Instance()->SetDumpSwitch(enDumpMiniDump, TRUE);

#ifdef RELEASE_VERSION
    CDumpCore::Instance()->SetDumpSwitch(enDumpCallStack, TRUE);
#else
    CDumpCore::Instance()->SetDumpSwitch(enDumpCallStack, FALSE);
#endif

    CDumpCore::Instance()->StartDumpDaemon();
    return S_OK;
}

HRESULT XCrashDump::DumpMiniDump(PEXCEPTION_POINTERS p)
{
    CDumpCore::Instance()->DumpDirectForTest(p);
    return S_OK;
}

HRESULT XCrashDump::EnsureHookIsWorking()
{
    CDumpCore::Instance()->InstallExceptionFilter();
    return S_OK;
}

HRESULT XCrashDump::SetDumpType(DumpType type, bool enable)
{
    CDumpCore::Instance()->SetDumpSwitch(type, enable ? TRUE : FALSE);
    return S_OK;
}
