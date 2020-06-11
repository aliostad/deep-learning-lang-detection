package io.gwynt.pipeline;

import io.gwynt.concurrent.EventExecutor;
import io.gwynt.ChannelPromise;
import io.gwynt.Handler;

public interface Pipeline {

    void addFirst(Handler handler);

    void addFirst(HandlerContextInvoker invoker, Handler handler);

    void addFirst(EventExecutor executor, Handler handler);

    void addFirst(String name, Handler handler);

    void addFirst(HandlerContextInvoker invoker, String name, Handler handler);

    void addFirst(EventExecutor executor, String name, Handler handler);

    void addLast(Handler handler);

    void addLast(HandlerContextInvoker invoker, Handler handler);

    void addLast(EventExecutor executor, Handler handler);

    void addLast(String name, Handler handler);

    void addLast(HandlerContextInvoker invoker, String name, Handler handler);

    void addLast(EventExecutor executor, String name, Handler handler);

    void addBefore(Handler handler, Handler before);

    void addBefore(HandlerContextInvoker invoker, Handler handler, Handler before);

    void addBefore(EventExecutor executor, Handler handler, Handler before);

    void addBefore(Handler handler, String beforeName);

    void addBefore(HandlerContextInvoker invoker, Handler handler, String beforeName);

    void addBefore(EventExecutor executor, Handler handler, String beforeName);

    void addBefore(String name, Handler handler, Handler before);

    void addBefore(HandlerContextInvoker invoker, String name, Handler handler, Handler before);

    void addBefore(EventExecutor executor, String name, Handler handler, Handler before);

    void addBefore(String name, Handler handler, String beforeName);

    void addBefore(HandlerContextInvoker invoker, String name, Handler handler, String beforeName);

    void addBefore(EventExecutor executor, String name, Handler handler, String beforeName);

    void addAfter(Handler handler, Handler after);

    void addAfter(HandlerContextInvoker invoker, Handler handler, Handler after);

    void addAfter(EventExecutor executor, Handler handler, Handler after);

    void addAfter(Handler handler, String afterName);

    void addAfter(HandlerContextInvoker invoker, Handler handler, String afterName);

    void addAfter(EventExecutor executor, Handler handler, String afterName);

    void addAfter(String name, Handler handler, Handler after);

    void addAfter(HandlerContextInvoker invoker, String name, Handler handler, Handler after);

    void addAfter(EventExecutor executor, String name, Handler handler, Handler after);

    void addAfter(String name, Handler handler, String afterName);

    void addAfter(HandlerContextInvoker invoker, String name, Handler handler, String afterName);

    void addAfter(EventExecutor executor, String name, Handler handler, String afterName);

    void remove(Handler handler);

    void remove(String name);

    void clear();

    void copy(Pipeline pipeline);

    void fireRegistered();

    void fireUnregistered();

    void fireOpen();

    void fireMessageReceived(Object message);

    void fireExceptionCaught(Throwable e);

    void fireRead(ChannelPromise channelPromise);

    void fireMessageSent(Object message, ChannelPromise channelPromise);

    void fireClosing(ChannelPromise channelPromise);

    void fireClose();
}
