/*
 * 获取系统cpu,load相关信息的类
 * created by guangchao.tian@opi-corp.com
 * 2010-03-19
 */


#ifndef __SYSINFO_H__
#define __SYSINFO_H__
#include <Singleton.h>
#include <fstream>

namespace xce {
namespace sysinfo{

using namespace std;

enum LOAD_TYPE
{
	LOAD_ONE = 1,
	LOAD_FIVE = 5,
	LOAD_FIFTEEN = 15
};

class SysInfo : public MyUtil::Singleton<SysInfo>
{
	public:

		/*
		 *  描述：初始化的时候读取一次cpu个数信息
		 */
		SysInfo()
		{
			_cpuNum = 0;
			FILE *f=popen("cat /proc/cpuinfo |grep processor |wc -l","r");
			fscanf(f,"%d",&_cpuNum);
			pclose(f);
		}
		
	public:

		/*
		 * 描述：根据当前load和cpu个数的比值判断当前系统是否highload
		 * 参数：type 表示获取load的类型，分为按1分钟，5分钟和15分钟；
		 *		 maxLoadPercent表示highload的阈值，如果使用默认值0，则认为超过1为highload
		 * 返回值：是返回true,否返回false
		 */
		bool isHighLoadByPercent(LOAD_TYPE type ,double maxLoadPercent = 0)
		{
			double loadNow = 0; 
			getLoad(type, loadNow);
		
			if( maxLoadPercent == (double)0)
			{
				return (loadNow / getCpuNum()) > 1;
			}else
			{
				return (loadNow / getCpuNum()) > maxLoadPercent;
			}
			return true;
		}
		
		/*
		 * 描述：根据当前load数的判断当前系统是否highload
		 * 参数：type 表示获取load的类型，分为按1分钟，5分钟和15分钟；
		 *		 maxLoad表示highload的阈值，如果使用默认值0，则认为超过cpu个数为highload
		 * 返回值：是返回true,否返回false
		 */
		bool isHighLoadByNum(LOAD_TYPE type, double maxLoad = 0)
		{
			double loadNow = 0; 
			getLoad(type, loadNow);
		
			if(maxLoad == (double)0)
			{
				return loadNow > getCpuNum();
			}else
			{
				return loadNow > maxLoad;
			}
			return true;
		}
		
		/*
		 * 描述：获得系统cpu的个数
		 * 返回值：cpu个数
		 */
		int getCpuNum()
		{
			return _cpuNum;
		}

		/*
		 * 描述：获得系统当前1分钟的load
		 * 参数：load为外部调用传进来的引用，将把当前的load值赋给该参数
		 * 返回值：为是否取得load成功
		 */
		bool getLoadOne(double& load)
		{
			if(getLoad(LOAD_ONE,load))
			{
				return true;
			}
			return false;
		}
		
		/*
		 * 描述：获得系统当前5分钟的load
		 * 参数：load为外部调用传进来的引用，将把当前的load值赋给该参数
		 * 返回值：为是否取得load成功
		 */
		bool getLoadFive(double& load)
		{
			if(getLoad(LOAD_FIVE,load))
			{
				return true;
			}
			return false;
		}
	
		/*
		 * 描述：获得系统当前15分钟的load
		 * 参数：load为外部调用传进来的引用，将把当前的load值赋给该参数
		 * 返回值：为是否取得load成功
		 */
		bool getLoadFifteen(double& load)
		{
			if(getLoad(LOAD_FIFTEEN,load))
			{
				return true;
			}
			return false;
		}
		
		/*
		 * 描述：根据type信息获得系统当前的load
		 * 参数：type为获取load信息的类型，分为1分钟，5分钟和15分钟；
		 *		 load为外部调用传进来的引用，将把当前的load值赋给该参数
		 * 返回值：为是否取得load成功
		 */
		bool getLoad(LOAD_TYPE type, double& load)
		{ 
			double loadInfo[3];
			if (3==getloadavg(loadInfo,3))
			{
				switch(type)
				{
					case LOAD_ONE:
						load = loadInfo[0];
						return true;
						break;
					case LOAD_FIVE:
						load = loadInfo[1];
						return true;
						break;
					case LOAD_FIFTEEN:
						load = loadInfo[2];
						return true;
						break;
				}
			}
			return false;
		}
	
	private:

		/*
		 * 系统cpu的个数
		 */
		int _cpuNum;
};

};
};
#endif
