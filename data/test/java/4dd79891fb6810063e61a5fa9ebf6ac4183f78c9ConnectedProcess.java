package com.heap3d.implementations.application;

import com.sun.jdi.VirtualMachine;

/**
 * Created by oskar on 06/11/14.
 */
public class ConnectedProcess {

    private final VirtualMachine _virtualMachine;
    private final Process _process;

    public ConnectedProcess(VirtualMachine virtualMachine, Process process) {
        this._process = process;
        this._virtualMachine = virtualMachine;
    }

    public VirtualMachine getVirtualMachine() {
        return _virtualMachine;
    }

    public Process getProcess() {
        return _process;
    }
}
