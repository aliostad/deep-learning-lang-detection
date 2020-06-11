package com.fedomn;

/**
 * Created by fedomn on 2015/5/31.
 */
public class ResponseMaker {

    public static String translate(String request) {
        RequestHandler commonRequestHandler = new CommonRequestHandler(null);
        RequestHandler officeHandler = new OfficeHandler(commonRequestHandler);
        RequestHandler officeFirstHandler = new OfficeFirstHandler(officeHandler);
        RequestHandler playHandler = new PlayHandler(officeFirstHandler);
        RequestHandler playFirstHandler = new PlayFirstHandler(playHandler);
        return playFirstHandler.handler(request);
    }
}
