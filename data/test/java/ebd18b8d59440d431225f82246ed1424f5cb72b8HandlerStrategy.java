package com.security.examples.queryBuilder.handlers;

import com.security.examples.queryBuilder.domain.vo.HandlerType;

/**
 * Created by trevor on 2/21/15.
 */
public class HandlerStrategy {
    public static Handler getHandler(HandlerType allowedType){
        Handler handler;
        switch(allowedType){
            case BOOLEAN:
                handler = new DefaultHandler();
                break;
            case CHAR :
                handler = new DefaultHandler();
                break;
            case DOUBLE:
                handler = new DefaultHandler();
                break;
            case FLOAT:
                handler = new DefaultHandler();
                break;
            case INT :
                handler = new DefaultHandler();
                break;
            case LONG:
                handler = new DefaultHandler();
                break;
            case STRING:
                handler = new StringHandler();
                break;
            case URI :
                handler = new URIHandler();
                break;
            default:
                throw new IllegalArgumentException("Handler does not exist for "+allowedType.name());
        }
        return handler;
    }
}
