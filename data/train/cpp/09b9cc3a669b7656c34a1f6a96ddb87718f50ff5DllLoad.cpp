// Rocky 2010-04-15 19:29:32
#include "DllLoad.h"
#include "DllLoad_Linux.h"
namespace DLLLOAD_SPACE
{







DllLoad::DllLoad()
{
    FUNCTION_TRACK(); // 函数轨迹跟综
}

DllLoad::~DllLoad()
{
    FUNCTION_TRACK(); // 函数轨迹跟综
}


// 跟据传入的id从工厂中产生一个处理对象
DllLoad *DllLoad::New(const string &id/*="linux"*/)
{
    return new DllLoad_Linux;
}



// 打开动态库文件
int DllLoad::Open(const string &file)
{
    FUNCTION_TRACK(); // 函数轨迹跟综
    LOG_ERROR("应在子类中实现");
    return ERR;
}

// 关闭动态库
int DllLoad::Close()
{
    FUNCTION_TRACK(); // 函数轨迹跟综
    LOG_ERROR("应在子类中实现");
    return ERR;
}

// 取执行对象
void *DllLoad::GetSymbol(const string &sym)
{
    FUNCTION_TRACK(); // 函数轨迹跟综
    LOG_ERROR("应在子类中实现");
    return NULL;
}










}// end of DLLLOAD_SPACE
