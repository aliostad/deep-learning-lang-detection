package com.jt.pattern.chain;

/**
 * @author ze.liu
 * @since 2014/5/15
 */
public class ConcreteHandler extends Handler {

    public ConcreteHandler(String name) {
        super(name);
    }


    @Override
    public void doHandler() {
        if (getHandler() != null) {
            nextHandler.doHandler();
            System.out.println(name + " other do");
        } else {
            System.out.println(name + " I do");
        }
    }


    public static void main(String[] args) {
        Handler h1 = new ConcreteHandler("h1");
        Handler h2 = new ConcreteHandler("h2");
        h1.setNextHandler(h2);
        h1.doHandler();

    }
}
