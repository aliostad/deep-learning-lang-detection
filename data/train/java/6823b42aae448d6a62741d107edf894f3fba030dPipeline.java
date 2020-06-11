package io.gwynt.core.pipeline;

import io.gwynt.core.IoHandler;

public interface Pipeline {

    void addFirst(IoHandler ioHandler);

    void addFirst(String name, IoHandler ioHandler);

    void addLast(IoHandler ioHandler);

    void addLast(String name, IoHandler ioHandler);

    void addBefore(IoHandler ioHandler, IoHandler before);

    void addBefore(IoHandler ioHandler, String beforeName);

    void addBefore(String name, IoHandler ioHandler, IoHandler before);

    void addBefore(String name, IoHandler ioHandler, String beforeName);

    void addAfter(IoHandler ioHandler, IoHandler after);

    void addAfter(IoHandler ioHandler, String afterName);

    void addAfter(String name, IoHandler ioHandler, IoHandler after);

    void addAfter(String name, IoHandler ioHandler, String afterName);

    void remove(IoHandler ioHandler);

    void remove(String name);
}
