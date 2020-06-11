package com.example.web.mapping;

import com.example.web.handler.SpecialHandler;
import org.springframework.web.servlet.handler.AbstractUrlHandlerMapping;

import javax.servlet.http.HttpServletRequest;

/**
 * Created by dwb on 2017/6/14.
 */
public class SpecialHandlerMapping extends AbstractUrlHandlerMapping {
    private final String SPECIAL_PATH = "/special";

    private SpecialHandler handler;

    public SpecialHandlerMapping(SpecialHandler handler){
        this.handler = handler;
        setOrder(-1000);
        this.registerHandler(SPECIAL_PATH, this.handler);
    }

    public void registerHandler(String urlPath, Object handler){
        super.registerHandler(urlPath,handler);
    }

    protected Object lookupHandler(String urlPath, HttpServletRequest request) throws Exception {
        return super.lookupHandler(urlPath, request);
    }
}
