package com.adobe.www.exception;

import com.adobe.www.exception.service.Service;

public class ServiceInvocation {
	/**
	 * 该方法是service总的调用接口,所以能在这里统一处理异常
	 * @param serviceMapping
	 * @return
	 */
	public static Object execution(ServiceMapping serviceMapping){
		/**
		 * serviceMapping
		 *   serviceClass cn.itcast.exception.service.StudentServiceImpl
		 *   methodName   savePerson
		 */
		try{
			Service service = (Service)Class.forName(serviceMapping.getServiceClass()).newInstance();
			service.service(serviceMapping);
		}catch(Exception e){
			e.printStackTrace();
		}
		return null;
	}
}
