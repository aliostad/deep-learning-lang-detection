package com.xiaoheiwu.service.annotation.util;

import java.lang.annotation.Annotation;

import com.xiaoheiwu.service.annotation.Service;

public class ServiceUtils {
	public static String DEFUALT_VERSION="1.0";
	public static String getServiceName(Class serviceClass){
		Annotation service = serviceClass.getAnnotation(Service.class);
		if(service==null)return serviceClass.getName();
		return ((Service)service).value();
	}
	
	public static String getVersion(Class serviceClass){
		Annotation service = serviceClass.getAnnotation(Service.class);
		if(service==null)return DEFUALT_VERSION;
		return ((Service)service).version();
	}
}
