package com.crazywars.km.core;

import javax.faces.context.ExceptionHandler;
import javax.faces.context.ExceptionHandlerFactory;

public class KmExceptionHandlerFactory extends ExceptionHandlerFactory {
   private ExceptionHandlerFactory parent;

   // this injection handles jsf
   public KmExceptionHandlerFactory(ExceptionHandlerFactory parent) {
      this.parent = parent;
   }

   @Override
   public ExceptionHandler getExceptionHandler() {
      ExceptionHandler handler = new KmExceptionHandler(parent.getExceptionHandler());
      return handler;
   }

}
