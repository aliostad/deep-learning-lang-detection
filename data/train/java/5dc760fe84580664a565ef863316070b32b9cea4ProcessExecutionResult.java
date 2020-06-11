/*
 * Copyright (c) 2014 Kloudtek Ltd
 */

package com.kloudtek.util;

/**
 * Result of a process execution
 */
public class ProcessExecutionResult {
    private Process process;
    private String stdout;

    public ProcessExecutionResult(Process process, String stdout) {
        this.process = process;
        this.stdout = stdout;
    }

    public Process getProcess() {
        return process;
    }

    public void setProcess(Process process) {
        this.process = process;
    }

    public String getStdout() {
        return stdout;
    }

    public void setStdout(String stdout) {
        this.stdout = stdout;
    }
}
