package com.tor.sun.misc;

import sun.misc.Signal;
import sun.misc.SignalHandler;

/**
 * User: tor
 * Date: 16.03.15
 * Time: 12:50
 * http://habrahabr.ru/post/78035/
 */
public class DiagnosticSignalHandler implements SignalHandler {
    // Static method to install the signal handler
    public static void install(String signalName, SignalHandler handler) {
        Signal signal = new Signal(signalName);
        DiagnosticSignalHandler diagnosticSignalHandler = new DiagnosticSignalHandler();
        SignalHandler oldHandler = Signal.handle(signal, diagnosticSignalHandler);
        diagnosticSignalHandler.setHandler(handler);
        diagnosticSignalHandler.setOldHandler(oldHandler);
    }
    private SignalHandler oldHandler;
    private SignalHandler handler;

    private DiagnosticSignalHandler() {
    }

    private void setOldHandler(SignalHandler oldHandler) {
        this.oldHandler = oldHandler;
    }

    private void setHandler(SignalHandler handler) {
        this.handler = handler;
    }

    // Signal handler method
    @Override
    public void handle(Signal sig) {
        System.out.println("Diagnostic Signal handler called for signal " + sig);
        try {
            handler.handle(sig);

            // Chain back to previous handler, if one exists
            if (oldHandler != SIG_DFL && oldHandler != SIG_IGN) {
                oldHandler.handle(sig);
            }

        } catch (Exception e) {
            System.out.println("Signal handler failed, reason " + e);
        }
    }
}
