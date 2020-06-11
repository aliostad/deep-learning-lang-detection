package org.raowei.test.pattern.responsibilechan;

/**
 * @author raow
 * @version 2015-08-28
 * @since 1.0
 * Copyright ©   e路同心（www.88bank.com）  All right reserved
 */
public class managerHandler implements Handler {
    private Handler handler;

    @Override
    public void setHandler(Handler handler) {
        this.handler = handler;
    }

    @Override
    public void handler(String user, double fee) {
        Handler handler = this.getHandler();
        System.out.println("manger handler");
        if ("myself".equals(user) && fee < 1000) {
            System.out.println("经理批了");
        } else {
            if (handler == null)
                throw new IllegalArgumentException("没有处理对象 handler is null");
            handler.getHandler().handler(user, fee);
        }

    }

    @Override
    public Handler getHandler() {
        return this.handler;
    }
}
