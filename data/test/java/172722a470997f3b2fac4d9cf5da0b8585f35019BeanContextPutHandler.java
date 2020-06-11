/********************************************************************
 
********************************************************************/ 
package jtersow.interceptors;

import jtersow.components.AppHandler;
import jtersow.servlet.application.InterceptorHandler;

public class BeanContextPutHandler extends InterceptorHandler{
  /*=======================================================
  
  =======================================================*/
  public void doHandler(AppHandler handler){
    handler.getContext().setProperty("appHandler",handler);
    if(!handler.inContext())
      handler.getContext().setProperty(handler.getBeanName(),handler.getBean());
  }
}
