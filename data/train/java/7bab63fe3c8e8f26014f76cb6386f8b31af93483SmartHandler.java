package com.chrisgammage.gwtjitsu.client;

import com.google.gwt.event.shared.HandlerRegistration;

/**
 * Created with IntelliJ IDEA.
 * User: gammagec
 * Date: 10/26/12
 * Time: 5:00 PM
 */
public class SmartHandler {

  private HandlerRegistration handlerRegistration;

  public void set(HandlerRegistration handlerRegistration) {
    if(this.handlerRegistration != null) {
      this.handlerRegistration.removeHandler();
    }
    this.handlerRegistration = handlerRegistration;
  }

  public void release() {
    if(handlerRegistration != null) {
      handlerRegistration.removeHandler();
      handlerRegistration = null;
    }
  }
}
