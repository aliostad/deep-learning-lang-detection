package com.sunlights.customer.service.rewardrules;

import java.util.List;

/**
 * 活动处理的执行链
 * 包括：
 * 1：处理活动的动作响应：获取奖励、兑换奖励等和活动有关的动作的响应
 * 2：处理活动前的过滤和处理完之后的过滤
 * <p/>
 * <p/>
 * Created by tangweiqun on 2014/12/1.
 */
public class HandlerExecutionChain {
    private Object handler;

    private List<HandlerInterceptor> interceptorList;

    public HandlerExecutionChain(Object handler) {
        this(handler, null);
    }

    public HandlerExecutionChain(Object handler, List<HandlerInterceptor> handlerInterceptors) {
        this.handler = handler;
        this.interceptorList = handlerInterceptors;
    }

    public Object getHandler() {
        return handler;
    }

    public List<HandlerInterceptor> getInterceptorList() {
        return interceptorList;
    }
}
