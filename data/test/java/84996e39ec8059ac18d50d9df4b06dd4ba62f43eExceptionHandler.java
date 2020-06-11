package one.koslowski.world.api;

import one.koslowski.world.api.event.ExceptionEvent;

public abstract class ExceptionHandler
{
  private ExceptionHandler parent;

  ExceptionHandler()
  {

  }

  protected ExceptionHandler(ExceptionHandler parent)
  {
    this.parent = parent;
  }

  void trap(ExceptionEvent event)
  {
    ExceptionHandler handler = this;

    while (!handler.handle(event) && handler.parent != null)
      handler = handler.parent;
  }

  protected abstract boolean handle(ExceptionEvent event);
}
