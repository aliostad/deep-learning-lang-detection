/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package mx.gob.ifr.scheduler.core.services;

import mx.gob.ifr.scheduler.events.process.ProcessErrorsEvent;
import mx.gob.ifr.scheduler.events.process.ProcessLogDetailsEvent;
import mx.gob.ifr.scheduler.events.process.ProcessLogListEvent;
import mx.gob.ifr.scheduler.events.process.ProcessLogsEvent;
import mx.gob.ifr.scheduler.events.process.RequestProcessDetailsEvent;
import mx.gob.ifr.scheduler.events.process.RequestProcessErrorsEvent;
import mx.gob.ifr.scheduler.events.process.RequestProcessLogEvent;
import mx.gob.ifr.scheduler.events.process.RequestProcessLogPageableEvent;
import mx.gob.ifr.scheduler.events.process.RequestProcessLogsEvent;

/**
 *
 * @author marco-g8
 */
public interface ProcessLogService {
    
    public ProcessLogListEvent requestAllProcess (RequestProcessLogEvent event);
    
    public ProcessLogListEvent requestAllProcess(RequestProcessLogPageableEvent event);
    
    public ProcessLogListEvent requestLast10Process (RequestProcessLogEvent event);
    
    public ProcessLogDetailsEvent requestProcessDetails(RequestProcessDetailsEvent event);
    
    public ProcessLogsEvent requestProcessLogs  (RequestProcessLogsEvent event);
    
    public ProcessErrorsEvent requestProcessErrors (RequestProcessErrorsEvent event);
    
}
