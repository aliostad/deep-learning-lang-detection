package com.gendata.faces.validation.core;

import javax.faces.application.ViewHandler;
import javax.faces.context.FacesContext;

public class ViewHandlerFactory {

   private static VisitorViewHandler viewHandler = null;

   private ViewHandlerFactory() {
      // empty
   }

   public static synchronized ViewHandler getHandler(final ViewHandler parent) {
      if (viewHandler == null) {
         viewHandler = new VisitorViewHandler(parent);
         viewHandler.initialize(FacesContext.getCurrentInstance());
      }

      return viewHandler;
   }

}
