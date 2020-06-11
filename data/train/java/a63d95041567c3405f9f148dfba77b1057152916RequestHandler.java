package org.microsauce.gravy.runtime;

import org.microsauce.gravy.context.Handler;
import org.microsauce.gravy.context.ServletFacade;

public class RequestHandler {
    public Handler getHandler() {
        return handler;
    }

    public void setHandler(Handler handler) {
        this.handler = handler;
    }

    public ServletFacade getServlet() {
        return servlet;
    }

    public void setServlet(ServletFacade servlet) {
        this.servlet = servlet;
    }

    private Handler handler;
    private ServletFacade servlet;
}
