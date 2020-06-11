/********************************************************************
 
********************************************************************/ 
package jtersow.interceptor;

import jtersow.component.AppHandler;
import jtersow.servlet.application.InterceptorHandler;

public class BeanContextRemoveHandler extends InterceptorHandler{
  /*=======================================================
  
  =======================================================*/
  public void doHandler(AppHandler handler){
    handler.getContext().removeProperty("appHandler");
    if(!handler.inContext())
      handler.getContext().removeProperty(handler.getBeanName());
  } 
}
