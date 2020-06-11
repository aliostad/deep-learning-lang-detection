package org.jbpm.osgi.persistent.example;

import org.kie.api.event.process.*;

public class LoggingProcessEventListener implements ProcessEventListener {
    public void beforeProcessStarted(ProcessStartedEvent processStartedEvent) {
        System.out.println("LoggingProcessEventListener :: beforeProcessStarted");
    }

    public void afterProcessStarted(ProcessStartedEvent processStartedEvent) {
        System.out.println("LoggingProcessEventListener :: afterProcessStarted");
    }

    public void beforeProcessCompleted(ProcessCompletedEvent processCompletedEvent) {
        System.out.println("LoggingProcessEventListener :: beforeProcessCompleted");
    }

    public void afterProcessCompleted(ProcessCompletedEvent processCompletedEvent) {
        System.out.println("LoggingProcessEventListener :: afterProcessCompleted");
    }

    public void beforeNodeTriggered(ProcessNodeTriggeredEvent processNodeTriggeredEvent) {
        System.out.println("LoggingProcessEventListener :: beforeNodeTriggered");
    }

    public void afterNodeTriggered(ProcessNodeTriggeredEvent processNodeTriggeredEvent) {
        System.out.println("LoggingProcessEventListener :: afterNodeTriggered");
    }

    public void beforeNodeLeft(ProcessNodeLeftEvent processNodeLeftEvent) {
        System.out.println("LoggingProcessEventListener :: beforeNodeLeft");
    }

    public void afterNodeLeft(ProcessNodeLeftEvent processNodeLeftEvent) {
        System.out.println("LoggingProcessEventListener :: afterNodeLeft");
    }

    public void beforeVariableChanged(ProcessVariableChangedEvent processVariableChangedEvent) {
        System.out.println("LoggingProcessEventListener :: beforeVariableChanged");
    }

    public void afterVariableChanged(ProcessVariableChangedEvent processVariableChangedEvent) {
        System.out.println("LoggingProcessEventListener :: afterVariableChanged");
    }
}
