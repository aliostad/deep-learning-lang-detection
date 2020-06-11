package de.androbit.nibbler.dsl;

import de.androbit.nibbler.http.RestHttpMethod;
import de.androbit.nibbler.http.RestRequestHandler;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class PathDefinition {
  final String pathTemplate;

  public PathDefinition(String pathTemplate) {
    this.pathTemplate = pathTemplate;
  }

  Map<RestHttpMethod, List<HandlerDefinition>> methodHandlers = new HashMap<>();

  public PathDefinition get(RestRequestHandler handler) {
    return get(new HandlerDefinition().withRequestHandler(handler));
  }

  public PathDefinition get(HandlerDefinition handler) {
    return addHandler(handler.withHttpMethod(RestHttpMethod.GET));
  }

  public PathDefinition post(RestRequestHandler handler) {
    return post(new HandlerDefinition().withRequestHandler(handler));
  }

  public PathDefinition post(HandlerDefinition handler) {
    return addHandler(handler.withHttpMethod(RestHttpMethod.POST));
  }

  public PathDefinition put(RestRequestHandler handler) {
    return put(new HandlerDefinition().withRequestHandler(handler));
  }

  public PathDefinition put(HandlerDefinition handler) {
    return addHandler(handler.withHttpMethod(RestHttpMethod.PUT));
  }

  public PathDefinition delete(RestRequestHandler handler) {
    return delete(new HandlerDefinition().withRequestHandler(handler));
  }

  public PathDefinition delete(HandlerDefinition handler) {
    return addHandler(handler.withHttpMethod(RestHttpMethod.DELETE));
  }

  public PathDefinition patch(RestRequestHandler handler) {
    return patch(new HandlerDefinition().withRequestHandler(handler));
  }

  public PathDefinition patch(HandlerDefinition handler) {
    return addHandler(handler.withHttpMethod(RestHttpMethod.PATCH));
  }

  public PathDefinition head(RestRequestHandler handler) {
    return head(new HandlerDefinition().withRequestHandler(handler));
  }

  public PathDefinition head(HandlerDefinition handler) {
    return addHandler(handler.withHttpMethod(RestHttpMethod.HEAD));
  }

  public PathDefinition options(RestRequestHandler handler) {
    return options(new HandlerDefinition().withRequestHandler(handler));
  }

  public PathDefinition options(HandlerDefinition handler) {
    return addHandler(handler.withHttpMethod(RestHttpMethod.OPTIONS));
  }

  protected PathDefinition addHandler(HandlerDefinition handlerDefinition) {
    List<HandlerDefinition> methodHandlers = getOrCreateMethodHandlerList(handlerDefinition.getRestHttpMethod());
    methodHandlers.add(handlerDefinition);
    return this;
  }

  protected List<HandlerDefinition> getOrCreateMethodHandlerList(RestHttpMethod restHttpMethod) {
    if (methodHandlers.get(restHttpMethod) == null) {
      methodHandlers.put(restHttpMethod, new ArrayList<>());
    }
    return methodHandlers.get(restHttpMethod);
  }

  public Map<RestHttpMethod, List<HandlerDefinition>> getMethodHandlers() {
    return methodHandlers;
  }

  public String getPathTemplate() {
    return pathTemplate;
  }

  @Override
  public String toString() {
    return "PathDefinition{" +
      "pathTemplate='" + pathTemplate + '\'' +
      ", methodHandlers=" + methodHandlers +
      '}';
  }
}
