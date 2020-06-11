package com.mapflow.geo.logging.service.locator;

import org.springframework.beans.factory.annotation.Autowired;

import com.mapflow.geo.logging.service.LoggerService;

public class ServiceLocatorImpl implements ServiceLocator {

  @Autowired
  private LoggerService loggerService;

  public LoggerService getLoggerService() {
    return loggerService;
  }

  @Override
  public LoggerService loggerServiceFinder() {

    return getLoggerService();
  }

  public void setLoggerService(final LoggerService loggerService) {
    this.loggerService = loggerService;
  }

}
