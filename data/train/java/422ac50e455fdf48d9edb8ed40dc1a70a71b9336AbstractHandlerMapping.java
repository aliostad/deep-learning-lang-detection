package com.sunlights.customer.service.rewardrules;


import com.sunlights.customer.service.rewardrules.vo.ActivityRequestVo;

/**
 * Created by tangweiqun on 2014/12/1.
 */
public abstract class AbstractHandlerMapping implements HandlerMapping {

    private Object defaultHandler;

    public Object getDefaultHandler() {
        return defaultHandler;
    }

    public void setDefaultHandler(Object defaultHandler) {
        this.defaultHandler = defaultHandler;
    }

    @Override
    public HandlerExecutionChain getHandler(ActivityRequestVo requestVo) throws Exception {
        Object handler = getHandlerInternal(requestVo);
        if (handler == null) {
            handler = defaultHandler;
        }

        if (handler == null) {
            return null;
        }

        if (handler instanceof String) {
            String handlerName = (String) handler;
            handler = Class.forName(handlerName).newInstance();
        }
        return getHandlerExcutionChain(handler, requestVo);
    }

    public abstract Object getHandlerInternal(ActivityRequestVo requestVo) throws Exception;

    public HandlerExecutionChain getHandlerExcutionChain(Object handler, ActivityRequestVo requestVo) {
        HandlerExecutionChain chain = (handler instanceof HandlerExecutionChain) ? (HandlerExecutionChain) handler : new HandlerExecutionChain(handler);
        //TODO 在这里将过滤器组合到chain中
        return chain;
    }
}
