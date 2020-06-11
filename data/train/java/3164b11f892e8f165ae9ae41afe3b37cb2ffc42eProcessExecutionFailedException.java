/*
 * Copyright (c) 2014 Kloudtek Ltd
 */

package com.kloudtek.util;

/**
 * Thrown when a launched process's return code isn't zero.
 */
public class ProcessExecutionFailedException extends Exception {
    private static final long serialVersionUID = -2331325732059820363L;
    private Process process;
    private String stdout;

    public ProcessExecutionFailedException(Process process, String stdout) {
        super(stdout);
        this.process = process;
        this.stdout = stdout;
    }

    public Process getProcess() {
        return process;
    }

    public String getStdout() {
        return stdout;
    }
}
