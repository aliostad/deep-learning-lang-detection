package com.hbs.application;

import javax.faces.context.ExceptionHandler;
import javax.faces.context.ExceptionHandlerFactory;

/**
 * Created by XUZH on 12/30/13.
 */
public class HBSExceptionHandlerFactory extends ExceptionHandlerFactory {
  private ExceptionHandlerFactory base;

  private HBSExceptionHandler cached;

  public HBSExceptionHandlerFactory(HBSExceptionHandler cached) {
    this.cached = cached;
  }

  public HBSExceptionHandlerFactory(ExceptionHandlerFactory base) {
    this.base = base;
  }

  @Override
  public ExceptionHandler getExceptionHandler() {
    if (cached == null) {
      cached = new HBSExceptionHandler(base.getExceptionHandler());
    }

    return cached;
  }
}
