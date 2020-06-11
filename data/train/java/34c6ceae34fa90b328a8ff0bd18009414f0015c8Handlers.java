/*
 * Copyright (c) 2013. Ground Zero Labs, Private Company.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package io.hightide;

import io.hightide.exceptions.HandlerInitializationException;
import io.hightide.handlers.*;
import io.hightide.route.RoutesManager;
import io.hightide.security.SecurityHandler;
import io.undertow.server.HttpHandler;

/**
 * @author <a href="mailto:gpan@groundzerolabs.com">George Panagiotopoulos</a>
 */
public class Handlers {

    public static HttpHandler errors(final boolean debugMode, final HttpHandler nextHandler) {
        return new ErrorHandler(debugMode, nextHandler);
    }

    public static HttpHandler errors(final HttpHandler nextHandler) {
        return new ErrorHandler(nextHandler);
    }

    public static HttpHandler session(final HttpHandler nextHandler) {
        return new SessionHandler(nextHandler);
    }

    public static HttpHandler security(final HttpHandler nextHandler) {
        return new SecurityHandler(nextHandler);
    }

    public static HttpHandler monitor(final HttpHandler nextHandler) {
        return new MonitoringHandler(nextHandler);
    }

    public static HttpHandler forms(final HttpHandler nextHandler) {
        return new FormsHandler(nextHandler);
    }

    public static HttpHandler route(final RoutesManager routesManager, final HttpHandler nextHandler)
    throws HandlerInitializationException {
        return new RouteHandler(routesManager, nextHandler);
    }

    public static HttpHandler invocation(final HttpHandler nextHandler) {
        return new InvocationHandler(nextHandler);
    }

    public static HttpHandler redirect(final HttpHandler nextHandler) {
        return new RedirectHandler(nextHandler);
    }

    public static HttpHandler respond() {
        return new RepresentationHandler();
    }
}
