package com.perfectomobile.intellij.shared.systemtools.os;


import com.perfectomobile.intellij.shared.connector.LogAdapter;

import java.io.IOException;
import java.util.List;

public class ProcessExecutor {
    private final LogAdapter logger;

    public ProcessExecutor(LogAdapter logger) {
        this.logger = logger;
    }

    public Process syncExecOsProcess(final List<String> processCommands) throws IOException {
        final Process process = startProcess(processCommands);
        try {
            process.waitFor();
        } catch (InterruptedException e) {
            logger.debug(String.format("Interrupted while executing OS process %s", processCommands));
        }
        return process;
    }

    public Process startProcess(List<String> processCommands) throws IOException {
        final ProcessBuilder processBuilder = new ProcessBuilder(processCommands);
        return processBuilder.start();
    }
}
