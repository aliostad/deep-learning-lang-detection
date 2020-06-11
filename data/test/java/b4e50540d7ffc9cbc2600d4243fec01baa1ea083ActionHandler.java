/********************************************************************
 
********************************************************************/ 
package jtersow.interceptors;

import jtersow.components.AppHandler;
import jtersow.components.AppReflection;
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
