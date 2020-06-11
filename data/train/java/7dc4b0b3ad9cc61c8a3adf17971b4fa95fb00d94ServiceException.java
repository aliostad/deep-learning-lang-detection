package com.gni.frmk.tools.addon.invoker.api;

/**
 * Created by IntelliJ IDEA.
 * Date: 25/05/11
 * Time: 10:01
 *
 * @author: e03229
 */
public class
        ServiceException extends Exception {
    private final Service<?, ?> service;

    public ServiceException(Service<?, ?> service, String message) {
        super(message);
        this.service = service;
    }

    public ServiceException(Service<?, ?> service, Exception cause) {
        super(cause);
        this.service = service;
    }

    public Service<?, ?> getService() {
        return service;
    }
}
