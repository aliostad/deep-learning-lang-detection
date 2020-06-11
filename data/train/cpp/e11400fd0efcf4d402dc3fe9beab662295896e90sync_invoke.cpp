
#include "sync_invoke.h"

#include <process.h>


namespace klib{
namespace pattern{



sync_invoke::sync_invoke(void)
{
}


sync_invoke::~sync_invoke(void)
{
    CloseHandle(m_hThread);
}

bool sync_invoke::start()
{
    m_hThread = (HANDLE) _beginthreadex(NULL,
        0,
        &sync_invoke::workthread,
        this,
        0,
        NULL);
    
    return true;
}

bool sync_invoke::stop()
{
    PostThreadMessage(m_dwThreadID, WM_QUIT, 0, 0);

    WaitForSingleObject(m_hThread, INFINITE);

    return true;
}

unsigned int WINAPI sync_invoke::workthread(void* param)
{
    sync_invoke* pBgWorker = (sync_invoke*) param;
    pBgWorker->m_dwThreadID = GetCurrentThreadId();

    MSG msg;
    BOOL bRet = FALSE;
    
    do {
        bRet = GetMessage(&msg, NULL, 0, 0);
        if (bRet) 
        {
            if (msg.message == UM_CALL) 
            {
                std::function<void()>* fun = (std::function<void()>*) msg.wParam;
                (*fun)();
            }
        }
        else
        {
            break;
        }
        // Sleep(100);

    } while (bRet);

    return 0;
}



}}