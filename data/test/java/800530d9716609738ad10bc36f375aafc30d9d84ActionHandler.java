/********************************************************************
 
********************************************************************/ 
package jtersow.interceptor;

import jtersow.component.AppHandler;
import jtersow.component.AppReflection;
import jtersow.servlet.application.InterceptorHandler;

public class ActionHandler extends InterceptorHandler{
  /*=======================================================
  
  =======================================================*/
  public void doHandler(AppHandler handler)throws Exception{
    Object bean=handler.getBean();
    String beanMethod=handler.getBeanMethod();
    AppReflection reflection=handler.getReflection();
    Object result=reflection.execute(bean,beanMethod);
    
    handler.setResult(result);
  }
}
