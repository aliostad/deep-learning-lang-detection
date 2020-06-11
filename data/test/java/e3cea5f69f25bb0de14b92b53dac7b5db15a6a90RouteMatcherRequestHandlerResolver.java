package com.nicstrong.spark.webserver;

import org.apache.http.protocol.HttpRequestHandler;
import org.apache.http.protocol.HttpRequestHandlerResolver;


public class RouteMatcherRequestHandlerResolver implements HttpRequestHandlerResolver {
    private final MatcherApacheHttpHandler apacheHttpHandler;

    public RouteMatcherRequestHandlerResolver(MatcherApacheHttpHandler apacheHttpHandler) {
        this.apacheHttpHandler = apacheHttpHandler;
    }

    @Override public HttpRequestHandler lookup(String requestUri) {
        return apacheHttpHandler;
    }
}
