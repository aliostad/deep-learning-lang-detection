#ifndef __ISTREAMSYSTEM_H__
#define __ISTREAMSYSTEM_H__

/** 使用示例：

@code


uint streamLength = 0;

//////////////////////////////////////////////////////////////////////////
// 操作目录态的流系统
// 打开流系统
Handle dataHandle = openStreamSystem("e:/newlife/program/bin/data");
if (!isValidHandle(dataHandle))
	return;

// 打开流系统中的一个流
CStream* stream = openStream(dataHandle, "npc/npc1.dat");
if (stream)
	streamLength = stream->getLength();

// 关闭该流（这样就不会导致内存泄漏）
closeStream(stream);

// 关闭流系统
closeStreamSystem(dataHandle);

//////////////////////////////////////////////////////////////////////////
// 操作包态的流系统(跟上面类似，就下面一行的路径稍稍不同)
dataHandle = openStreamSystem("e:/newlife/program/bin/data.pkg");
if (!isValidHandle(dataHandle))
	return;

CStream* stream = openStream(dataHandle, "npc/npc1.dat");
if (stream)
	streamLength = stream->getLength();
closeStream(stream);

closeStreamSystem(dataHandle);


@endcode

 */

#include "Stream.h"
#include "Handle.h"

namespace xs{

/** 打开一个流系统
 @param streamSysPath 流路径（当传入文件时会当作包流开启，当传入目录时会当作目录流开启）
 @return 成功返回流系统的句柄，否则返回无效句柄
 */
Handle openStreamSystem(const char* streamSysPath);

/** 关闭一个流系统
 @param streamSysHandle 要关闭的流系统句柄
 @return 成功返回true，否则返回false
 */
bool closeStreamSystem(Handle streamSysHandle);

/** 检测流系统中是否存在指定的流对象
@param streamSysHandle 流系统句柄
@param streamName		指定的流的名字
@return 存在返回true，否则返回false
*/
bool findStream(Handle streamSysHandle, const char* streamName);

/** 从流系统中打开一个指定的流对象
 @param streamSysHandle 流系统句柄
 @param streamName		指定的流的名字
 @return 成功返回指定的流对象，否则返回NULL
 @see closeStream
 */
CStream* openStream(Handle streamSysHandle, const char* streamName);

/** 从流系统中枚举所有流
@param streamSysHandle 流系统句柄
@param pCallback	Callback接受枚举到的流名称
*/
void listStream(Handle streamSysHandle, IListStreamCallback* pCallback,void *p);

/** 关闭打开的流对象
 @param stream 要关闭的流对象
 */
void closeStream(CStream* stream);

}


#endif // __ISTREAMSYSTEM_H__
