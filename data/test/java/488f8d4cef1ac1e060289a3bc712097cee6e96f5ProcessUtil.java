/**
 * @Project Meituan
 * @Name ProcessUtil
 * @User Slbw
 * @Time 2015-1-28 下午3:23:40
 * @Version 1.0
 * @describe 
 */
package com.zkgame.autoapp.util;

import java.util.HashMap;

import javax.servlet.http.HttpSession;

/**
 * @author F
 *
 */
public class ProcessUtil {
	
	private static ProcessUtil processUtil;
	private HttpSession session;
	private HashMap<String,ProcessStatus> map;
	
	private ProcessUtil(HttpSession session)
	{
		map=new HashMap<String, ProcessStatus>();
		this.session=session;
	}
	
	public static ProcessUtil newInstance(HttpSession session)
	{
		if(processUtil==null)
		{
			processUtil=new ProcessUtil(session);
		}
		return processUtil;
	}
	
	public void setProcess(String cityId,String process,String status)
	{
		XLog.d(status+" "+process);
		ProcessStatus processStatus=new ProcessStatus();
		processStatus.setProcess(process);
		processStatus.setStatus(status);
		if(map.containsKey(cityId))
		{
			map.remove(cityId);
			map.put(cityId,processStatus);
		}
		else
		{
			map.put(cityId,processStatus);
		}
		if(session!=null)
		{
//			System.out.println(">>session:"+session.getId());
			session.setAttribute("updateStatus",map);
			
		}
	}

}
