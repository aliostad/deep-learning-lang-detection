package com.s4game.server.public_.card.rule.handler;

/**
 * handler context
 * 
 * @author zeusgooogle@gmail.com
 * @sine 2016年10月12日 下午4:08:24
 */
public class DefaultCardHandlerContext extends AbstractCardHandlerContext {

    private final CardHandler handler;
    
    DefaultCardHandlerContext(DefaultCardPipeline pipeline, String name, CardHandler handler) {
        super(pipeline, name);
        this.handler = handler;
    }

    @Override
    public CardHandler handler() {
        return handler;
    }
}
