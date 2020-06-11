package jornado;

public class RouteHandlerData<T extends Request> {
    private final Class<? extends Handler<T>> handlerClass;
    private final RouteData routeData;

    public RouteHandlerData(Class<? extends Handler<T>> handlerClass, RouteData routeData) {
        this.handlerClass = handlerClass;
        this.routeData = routeData;
    }

    public Class<? extends Handler<T>> getHandlerClass() {
        return handlerClass;
    }

    public RouteData getRouteData() {
        return routeData;
    }
}
