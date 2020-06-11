/*
 * @(#)NativeSignalHandler.java	1.7 03/12/19
 *
 * Copyright 2004 Sun Microsystems, Inc. All rights reserved.
 * SUN PROPRIETARY/CONFIDENTIAL. Use is subject to license terms.
 */

package sun.misc;

/* A package-private class implementing a signal handler in native code. */

final class NativeSignalHandler implements SignalHandler {

    private final long handler;

    long getHandler() {
        return handler;
    }

    NativeSignalHandler(long handler) {
        this.handler = handler;
    }

    public void handle(Signal sig) {
        handle0(sig.getNumber(), handler);
    }

    private static native void handle0(int number, long handler);
}
