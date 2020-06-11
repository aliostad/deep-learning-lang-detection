package pl.org.kata.test.client.tools;

import java.util.List;

import com.google.gwt.event.shared.EventHandler;
import com.google.gwt.event.shared.HandlerRegistration;

/**
 * @author Przemysław Gałązka
 * @since 16-05-2013
 */
public class HandlerRegistrationTestImpl<H> implements HandlerRegistration {

  private final H handler;
  private final List<EventHandler> handlers;


  public HandlerRegistrationTestImpl(H handler,
      List<EventHandler> handlers) {
    this.handler = handler;
    this.handlers = handlers;
  }


  @Override
  public void removeHandler() {
    handlers.remove(handler);
  }
}
