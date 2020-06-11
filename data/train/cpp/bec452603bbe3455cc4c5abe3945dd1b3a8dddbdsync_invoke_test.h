
#ifndef _klib_sync_invoke_test_h
#define _klib_sync_invoke_test_h


#include "pattern/sync_invoke.h"

using namespace klib::pattern;


TEST(sync_invoke_, 1)
{
    sync_invoke bgWorker;
    bgWorker.start();
    //Sleep(200); // 等待线程初始化完成

    TCHAR szMsg[100];
    _stprintf(szMsg, _T("当前主线程ID: %d \r\n"), GetCurrentThreadId());
    _tprintf(szMsg);

    bgWorker.send(
    [&](){
        //MessageBox(NULL, _T("要执行的操作"), _T("标题"), 0);
        printf("要执行的操作");
    });


    bgWorker.stop();
}

#endif
