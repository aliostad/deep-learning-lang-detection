package org.jspringbot.argument;

public class ArgumentHandlerRegistryBean implements ArgumentHandler {

    private ArgumentHandler handler;

    public ArgumentHandlerRegistryBean(ArgumentHandler handler) {
        this.handler = handler;
    }

    public ArgumentHandler getHandler() {
        return handler;
    }

    @Override
    public boolean isSupported(String keyword, Object parameter) {
        return handler.isSupported(keyword, parameter);
    }

    @Override
    public Object handle(Object parameter) {
        return handler.handle(parameter);
    }
}
