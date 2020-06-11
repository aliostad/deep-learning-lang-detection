package org.springframework.web.servlet.mvc.method.annotation;

import java.lang.reflect.Method;

import org.springframework.web.method.HandlerMethod;
import org.springframework.web.method.MyHandlerMethod;

public class MyRequestMappingHandlerMapping extends
		RequestMappingHandlerMapping {

	@Override
	protected HandlerMethod createHandlerMethod(Object handler, Method method) {
		MyHandlerMethod handlerMethod = null;
		if (handler instanceof String) {
			String beanName = (String) handler;
			handlerMethod = new MyHandlerMethod(beanName, getApplicationContext(), method);
		}
		else {
			//handlerMethod = new MyHandlerMethod(handler, method);
			throw new RuntimeException("Error : Create MyHandlerMethod");
		}
		return handlerMethod;
	}
	
}
