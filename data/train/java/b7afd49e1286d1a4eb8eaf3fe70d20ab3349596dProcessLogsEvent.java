/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package mx.gob.ifr.scheduler.events.process;

import java.util.List;

/**
 *
 * @author marco-g8
 */
public class ProcessLogsEvent {
    
    private final List<ProcessLogDetails> processLogs;

    public ProcessLogsEvent(final List<ProcessLogDetails> processLogs) {
        this.processLogs = processLogs;
    }

    public List<ProcessLogDetails> getProcessLogs() {
        return processLogs;
    }
    
    
    
}
