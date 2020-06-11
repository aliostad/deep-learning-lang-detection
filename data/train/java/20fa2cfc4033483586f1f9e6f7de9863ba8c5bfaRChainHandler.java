package com.dianping.swiftly.utils.chain;

/**
 * 责任链模式--抽象处理器
 * 
 * @author inter12
 */
public abstract class RChainHandler {

    private RChainHandler nextHandler;

    // 是否继续执行
    public boolean        isContinue = true;

    public abstract <T> T handleRequest(RChainContext context);

    public RChainHandler getNextHandler() {
        return nextHandler;
    }

    public void setNextHandler(RChainHandler nextHandler) {
        this.nextHandler = nextHandler;
    }

}
