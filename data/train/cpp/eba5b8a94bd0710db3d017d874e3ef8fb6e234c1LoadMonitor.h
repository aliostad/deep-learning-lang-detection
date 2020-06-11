/*
 * 监控系统当前load情况的基类
 * created by guangchao.tian@opi-corp.com
 * 2010-03-19
 */

#ifndef __XCE_UTIL_LOADMONITOR_H__
#define __XCE_UTIL_LOADMONITOR_H__

#include <Ice/Ice.h>
#include <SysInfo.h>

namespace MyUtil {

using namespace std;
using namespace xce::sysinfo;

class LoadMonitor : public IceUtil::Thread 
{

public:

	/*
	 * 描述：默认初始化函数（不建议使用）
	 */
	LoadMonitor() : _sleepSeconds(60), _maxLoadPercent(0.6), _maxLoadNum(6), _loadType(LOAD_ONE)
	{
		//启动线程
		start(65535).detach();
	}
	
	/*
	 * 描述：带参数的初始化函数
	 * 参数：sleepSeconds每次扫描系统load状态的间隔时间
	 *		 maxLoadPercent为根据load与cpu个数的比值判断是否highload的阈值
	 *		 maxLoadNum为根据load的值判断是否highload的阈值
	 *		 loadType为采样系统load信息的类型，分为1分钟，5分钟和15分钟
	 */
	LoadMonitor(int sleepSeconds, double maxLoadPercent, double maxLoadNum, LOAD_TYPE loadType): 
				_sleepSeconds(sleepSeconds), 
				_maxLoadPercent(maxLoadPercent), 
				_maxLoadNum(maxLoadNum),
				_loadType(loadType)
	{
		//启动线程
		start(65535).detach();
	}

	/*
	 * 线程运行的函数
	 */
	virtual void run()
	{
		//获取存有系统信息的对象
		SysInfo& si = SysInfo::instance();
		
		while(true)
		{
			double loadNumNow = 0;
			double loadPercentNow = 0;
			int cpuNum = 0;

		
			//获取当前系统的load信息，cpu信息
			si.getLoad(_loadType, loadNumNow);
			cpuNum = si.getCpuNum();
			loadPercentNow = loadNumNow/(double)cpuNum;
		
			//判断是否highload，超过percent或者个数的阈值均判断为highload
			if((si.isHighLoadByPercent(_loadType, _maxLoadPercent)) | (si.isHighLoadByNum(_loadType, _maxLoadNum)))
			{
				//系统highload,调用highload通知函数
				notifyHighLoad(loadNumNow, loadPercentNow);
			}else
			{
				//系统没有highload,调用正常的通知函数
				notifyLoadNow(loadNumNow, loadPercentNow);
			}
			
			//间隔指定时间再次检查
			sleep(_sleepSeconds);
		}
	}

protected:

	/*
	 * 描述：纯虚函数，子类必须实现，用于在收到highload的通知时进行相应的处理
	 * 参数：loadNumNow当前系统的load；loadPercentNow当前系统load与cpu个数的比值
	 */
	virtual void notifyHighLoad(double loadNumNow, double loadPercentNow) = 0;
	
	/*
	 * 描述：纯虚函数，子类必须实现，用于在收到load信息时进行相应的处理
	 * 参数：loadNumNow当前系统的load；loadPercentNow当前系统load与cpu个数的比值
	 */
	virtual void notifyLoadNow(double loadNumNow, double loadPercentNow) = 0;

protected:
	
	/*
	 * 描述：设置判断highload的信息
	 * 参数：sleepSeconds每次扫描系统load状态的间隔时间
	 *		 maxLoadPercent为根据load与cpu个数的比值判断是否highload的阈值
	 *		 maxLoadNum为根据load的值判断是否highload的阈值
	 *		 loadType为采样系统load信息的类型，分为1分钟，5分钟和15分钟
	 */
	void setConfig(double maxLoadNum, double maxLoadPercent, int sleepSeconds, LOAD_TYPE loadType)
	{
		_maxLoadNum = maxLoadNum;
		_maxLoadPercent = maxLoadPercent;
		_sleepSeconds = sleepSeconds;
		_loadType = loadType;
	}

private:

	/*
	 * 循环检查系统load的间隔
	 */
	int _sleepSeconds;
	
	/*
	 * 根据当前load与cpu个数的比值判断当前系统是否为highload的阈值
	 */
	double _maxLoadPercent;
	
	/*
	 * 根据当前load数的判断当前系统是否为highload的阈值
	 */
	double _maxLoadNum;
	
	/*
	 * 循环检查系统load的类型，分为1分钟，5分钟，15分钟
	 */
	LOAD_TYPE _loadType;
};

}

#endif

