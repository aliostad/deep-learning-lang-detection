package com.autoupdater.system.process.executors;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * Queue starting and returning Process' sequentially.
 */
public class ProcessQueue {
    private final List<ProcessBuilder> processBuilders;

    /**
     * Creates queue instance.
     */
    ProcessQueue() {
        this.processBuilders = new ArrayList<ProcessBuilder>();
    }

    /**
     * Creates queue instance.
     * 
     * @param processBuilders
     *            list of builders that will create queue
     */
    ProcessQueue(List<ProcessBuilder> processBuilders) {
        this.processBuilders = processBuilders != null ? processBuilders
                : new ArrayList<ProcessBuilder>();
    }

    /**
     * Starts and returns next Process.
     * 
     * @return next process if possible, null if none available
     * @throws IOException
     *             thrown if attempt to run of any of commands happen to fail
     *             (e.g. program doesn't exists)
     */
    public Process getNextProcess() throws IOException {
        if (processBuilders.isEmpty())
            return null;
        Process process = processBuilders.get(0).start();
        processBuilders.remove(0);
        return process;
    }

    /**
     * Returns true if queue is empty.
     * 
     * @return true if queue is empty, false otherwise
     */
    public boolean isEmpty() {
        return processBuilders.isEmpty();
    }
}
